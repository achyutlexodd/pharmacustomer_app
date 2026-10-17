import 'envelope.dart';

typedef MigrationStep = Map<String, dynamic> Function(Map<String, dynamic> oldData);

/// Manages schema evolutions across versions.
/// Applies migrations iteratively: v -> v+1 -> ... -> currentVersion.
class Migrator {
  final Map<int, MigrationStep> _steps = {};

  void registerMigration(int fromVersion, MigrationStep step) {
    _steps[fromVersion] = step;
  }

  /// Migrates an [Envelope] to [targetVersion].
  /// If the envelope version is greater than targetVersion, returns null (unknown newer version).
  /// If any required migration step is missing, returns null.
  Envelope? migrate(Envelope envelope, int targetVersion) {
    if (envelope.v > targetVersion) {
      return null;
    }

    var currentVersion = envelope.v;
    var currentData = Map<String, dynamic>.from(envelope.data);

    while (currentVersion < targetVersion) {
      final step = _steps[currentVersion];
      if (step == null) {
        // Missing migration step; fail safe and discard
        return null;
      }
      try {
        currentData = step(currentData);
        currentVersion++;
      } catch (_) {
        return null;
      }
    }

    return Envelope(
      v: targetVersion,
      savedAt: envelope.savedAt,
      userId: envelope.userId,
      data: currentData,
    );
  }
}
