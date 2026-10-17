import 'dart:io';
import '../../../core/storage/envelope.dart';
import '../../../core/storage/key_value_store.dart';
import '../../../core/storage/user_data_registry.dart';
import '../../../core/storage/write_coordinator.dart';

enum PrescriptionStatus {
  noneAttached,
  queued,
  uploading,
  uploaded,
  underReview,
  approved,
  rejected,
  expired,
}

extension PrescriptionStatusUi on PrescriptionStatus {
  String get chipLabel {
    switch (this) {
      case PrescriptionStatus.noneAttached:
        return 'Prescription required';
      case PrescriptionStatus.queued:
      case PrescriptionStatus.uploading:
        return 'Uploading…';
      case PrescriptionStatus.uploaded:
        return 'Ready for verification';
      case PrescriptionStatus.underReview:
        return 'Under review';
      case PrescriptionStatus.approved:
        return 'Approved';
      case PrescriptionStatus.rejected:
        return 'Rejected — re-upload';
      case PrescriptionStatus.expired:
        return 'Expired';
    }
  }
}

class Prescription {
  final String id;
  final String? localId;
  final String source; // 'upload' | 'link'
  final PrescriptionStatus status;
  final String fileName;
  final String mime;
  final int sizeBytes;
  final String? remoteUrl;
  final String? rejectionReason;
  final String? doctorName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Prescription({
    required this.id,
    this.localId,
    required this.source,
    required this.status,
    required this.fileName,
    required this.mime,
    required this.sizeBytes,
    this.remoteUrl,
    this.rejectionReason,
    this.doctorName,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'localId': localId,
        'source': source,
        'status': status.name,
        'fileName': fileName,
        'mime': mime,
        'sizeBytes': sizeBytes,
        'remoteUrl': remoteUrl,
        'rejectionReason': rejectionReason,
        'doctorName': doctorName,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      };

  static Prescription? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final source = json['source'];
    final statusName = json['status'];
    final fileName = json['fileName'];
    final mime = json['mime'];
    final sizeBytes = json['sizeBytes'];
    final createdAtRaw = json['createdAt'];
    final updatedAtRaw = json['updatedAt'];

    if (id is! String ||
        source is! String ||
        statusName is! String ||
        fileName is! String ||
        mime is! String ||
        sizeBytes is! int ||
        createdAtRaw is! String ||
        updatedAtRaw is! String) {
      return null;
    }

    final createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now().toUtc();
    final updatedAt = DateTime.tryParse(updatedAtRaw) ?? DateTime.now().toUtc();
    final status = PrescriptionStatus.values.firstWhere(
      (s) => s.name == statusName,
      orElse: () => PrescriptionStatus.uploaded,
    );

    return Prescription(
      id: id,
      localId: json['localId'] as String?,
      source: source,
      status: status,
      fileName: fileName,
      mime: mime,
      sizeBytes: sizeBytes,
      remoteUrl: json['remoteUrl'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      doctorName: json['doctorName'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class PrescriptionRepository implements UserScopedStore {
  static const int currentVersion = 1;
  final KeyValueStore store;
  final UserDataRegistry userDataRegistry;
  final Directory? appSupportDir;

  final Map<String, WriteCoordinator> _coordinators = {};

  PrescriptionRepository({
    required this.store,
    required this.userDataRegistry,
    this.appSupportDir,
  }) {
    userDataRegistry.registerStore(this);
  }

  String keyFor(String userId) => 'prescriptions.$userId';

  WriteCoordinator coordinatorFor(String userId) {
    final key = keyFor(userId);
    return _coordinators.putIfAbsent(key, () {
      final c = WriteCoordinator(key: key);
      userDataRegistry.registerCoordinator(c);
      return c;
    });
  }

  Future<List<Prescription>> hydrate(String userId) async {
    try {
      final key = keyFor(userId);
      final raw = await store.read(key);
      if (raw == null || raw.isEmpty) return [];

      final envelope = Envelope.decode(raw);
      if (envelope == null || envelope.userId != userId) return [];

      final rawList = envelope.data['prescriptions'];
      if (rawList is! List) return [];

      final items = <Prescription>[];
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          final p = Prescription.fromJson(item);
          if (p != null) items.add(p);
        }
      }
      return items;
    } catch (_) {
      return [];
    }
  }

  void schedulePersist(String userId, List<Prescription> items) {
    final coordinator = coordinatorFor(userId);
    coordinator.schedule(() async {
      final key = keyFor(userId);
      final envelope = Envelope(
        v: currentVersion,
        savedAt: DateTime.now().toUtc(),
        userId: userId,
        data: {
          'prescriptions': items.map((p) => p.toJson()).toList(),
        },
      );
      await store.write(key, envelope.encode());
    });
  }

  @override
  Future<void> wipeUser(String userId) async {
    final key = keyFor(userId);
    _coordinators[key]?.cancelAndDrop();
    await store.remove(key);

    // Delete prescription files in rx_uploads if present
    if (appSupportDir != null) {
      final rxDir = Directory('${appSupportDir!.path}/rx_uploads');
      if (await rxDir.exists()) {
        try {
          await rxDir.delete(recursive: true);
        } catch (_) {}
      }
    }
  }
}
