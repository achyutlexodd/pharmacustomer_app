import 'dart:async';
import '../logging/app_logger.dart';

typedef WriteAction = Future<void> Function();

/// Serializes and debounces writes for a given key.
/// - Trailing debounce: 250ms with maxWait: 1000ms.
/// - Serialized execution: only one in-flight write at a time.
/// - Generation token: drops stale writes after unbind/cancel.
/// - Retry policy: retry once after 500ms on failure.
class WriteCoordinator {
  final String key;
  final Duration debounceDuration;
  final Duration maxWaitDuration;
  final AppLogger? logger;

  Timer? _debounceTimer;
  Timer? _maxWaitTimer;
  WriteAction? _pendingAction;

  int _generation = 0;
  bool _isWriting = false;
  Completer<void>? _activeFlushCompleter;

  WriteCoordinator({
    required this.key,
    this.debounceDuration = const Duration(milliseconds: 250),
    this.maxWaitDuration = const Duration(milliseconds: 1000),
    this.logger,
  });

  int get currentGeneration => _generation;

  /// Schedules a write action with debouncing and max-wait safety.
  void schedule(WriteAction action) {
    _pendingAction = action;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, () {
      _triggerWrite();
    });

    _maxWaitTimer ??= Timer(maxWaitDuration, () {
      _triggerWrite();
    });
  }

  void _triggerWrite() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _maxWaitTimer?.cancel();
    _maxWaitTimer = null;

    if (_pendingAction == null) return;
    _executeQueue();
  }

  Future<void> _executeQueue() async {
    if (_isWriting) return;
    if (_pendingAction == null) {
      _activeFlushCompleter?.complete();
      _activeFlushCompleter = null;
      return;
    }

    _isWriting = true;
    final action = _pendingAction!;
    _pendingAction = null;
    final generationAtStart = _generation;

    try {
      if (generationAtStart != _generation) {
        // Cancelled/stale generation
        return;
      }
      await _runWithRetry(action, generationAtStart);
    } catch (e, st) {
      logger?.error('WriteCoordinator failed for key $key', e, st);
    } finally {
      _isWriting = false;
      if (_pendingAction != null && generationAtStart == _generation) {
        _executeQueue();
      } else {
        _activeFlushCompleter?.complete();
        _activeFlushCompleter = null;
      }
    }
  }

  Future<void> _runWithRetry(WriteAction action, int targetGeneration) async {
    try {
      await action();
    } catch (e) {
      if (targetGeneration != _generation) return;
      logger?.warning('WriteCoordinator retry for key $key after error: $e');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (targetGeneration != _generation) return;
      await action();
    }
  }

  /// Immediately flushes any queued write and awaits completion.
  Future<void> flush() async {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _maxWaitTimer?.cancel();
    _maxWaitTimer = null;

    if (_pendingAction == null && !_isWriting) {
      return;
    }

    _activeFlushCompleter ??= Completer<void>();
    _executeQueue();
    await _activeFlushCompleter?.future;
  }

  /// Cancels any scheduled timer and drops all pending writes.
  /// Advances generation so in-flight or delayed tasks are safely discarded.
  void cancelAndDrop() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _maxWaitTimer?.cancel();
    _maxWaitTimer = null;
    _pendingAction = null;
    _generation++;
    _activeFlushCompleter?.complete();
    _activeFlushCompleter = null;
  }
}
