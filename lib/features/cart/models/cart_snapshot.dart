import '../../../core/models/cart_item.dart';

class CartSnapshot {
  final List<CartItem> lines;
  final List<String> prescriptionIds;
  final int? revision;
  final DateTime? lastSyncedAt;

  const CartSnapshot({
    required this.lines,
    this.prescriptionIds = const [],
    this.revision,
    this.lastSyncedAt,
  });

  static const CartSnapshot empty = CartSnapshot(lines: [], prescriptionIds: []);

  Map<String, dynamic> toJson() => {
        'lines': lines.map((l) => l.toJson()).toList(),
        'prescriptionIds': prescriptionIds,
        'revision': revision,
        'lastSyncedAt': lastSyncedAt?.toUtc().toIso8601String(),
      };

  static CartSnapshot? fromJson(Map<String, dynamic> json) {
    final rawLines = json['lines'];
    if (rawLines is! List) return null;

    final lines = <CartItem>[];
    final seenIds = <String>{};

    for (final item in rawLines) {
      final parsed = CartItem.fromJson(item);
      if (parsed != null && !seenIds.contains(parsed.id)) {
        seenIds.add(parsed.id);
        lines.add(parsed);
      }
    }

    final rawRx = json['prescriptionIds'];
    final prescriptionIds = <String>[];
    if (rawRx is List) {
      for (final id in rawRx) {
        if (id is String && !prescriptionIds.contains(id)) {
          prescriptionIds.add(id);
        }
      }
    }

    final revision = json['revision'] as int?;
    final lastSyncedAtRaw = json['lastSyncedAt'];
    final lastSyncedAt =
        lastSyncedAtRaw is String ? DateTime.tryParse(lastSyncedAtRaw) : null;

    return CartSnapshot(
      lines: lines,
      prescriptionIds: prescriptionIds,
      revision: revision,
      lastSyncedAt: lastSyncedAt,
    );
  }
}
