import 'package:flutter/foundation.dart';

abstract interface class AppLogger {
  void debug(String message);
  void info(String message);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

/// Default logger implementation that ensures no PII or sensitive tokens leak in logs.
class ConsoleLogger implements AppLogger {
  final bool isRelease;

  const ConsoleLogger({this.isRelease = kReleaseMode});

  @override
  void debug(String message) {
    if (!isRelease && kDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }

  @override
  void info(String message) {
    if (!isRelease) {
      debugPrint('[INFO] $message');
    }
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[WARN] $message${error != null ? ' - Error: $error' : ''}');
    if (!isRelease && stackTrace != null) {
      debugPrint('$stackTrace');
    }
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message${error != null ? ' - Error: $error' : ''}');
    if (stackTrace != null) {
      debugPrint('$stackTrace');
    }
  }
}
