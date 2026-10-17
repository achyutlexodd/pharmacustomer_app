import '../../../core/storage/envelope.dart';
import '../../../core/storage/key_value_store.dart';
import '../../../core/storage/user_data_registry.dart';
import '../../../core/storage/write_coordinator.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  outForDelivery,
  delivered,
  cancelled,
  rejected,
  refunded,
}

class OrderItem {
  final String orderId;
  final OrderStatus status;
  final int totalPaise;
  final int itemCount;
  final DateTime createdAt;

  const OrderItem({
    required this.orderId,
    required this.status,
    required this.totalPaise,
    required this.itemCount,
    required this.createdAt,
  });

  bool get isActive =>
      status != OrderStatus.delivered &&
      status != OrderStatus.cancelled &&
      status != OrderStatus.rejected &&
      status != OrderStatus.refunded;

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'status': status.name,
        'totalPaise': totalPaise,
        'itemCount': itemCount,
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  static OrderItem? fromJson(Map<String, dynamic> json) {
    final orderId = json['orderId'];
    final statusName = json['status'];
    final totalPaise = json['totalPaise'];
    final itemCount = json['itemCount'];
    final createdAtRaw = json['createdAt'];

    if (orderId is! String ||
        statusName is! String ||
        totalPaise is! int ||
        itemCount is! int ||
        createdAtRaw is! String) {
      return null;
    }

    final createdAt = DateTime.tryParse(createdAtRaw);
    if (createdAt == null) return null;

    final status = OrderStatus.values.firstWhere(
      (s) => s.name == statusName,
      orElse: () => OrderStatus.placed,
    );

    return OrderItem(
      orderId: orderId,
      status: status,
      totalPaise: totalPaise,
      itemCount: itemCount,
      createdAt: createdAt,
    );
  }
}

class OrdersRepository implements UserScopedStore {
  static const int currentVersion = 1;
  final KeyValueStore store;
  final UserDataRegistry userDataRegistry;

  final Map<String, WriteCoordinator> _coordinators = {};

  OrdersRepository({
    required this.store,
    required this.userDataRegistry,
  }) {
    userDataRegistry.registerStore(this);
  }

  String keyFor(String userId) => 'orders.$userId';

  WriteCoordinator coordinatorFor(String userId) {
    final key = keyFor(userId);
    return _coordinators.putIfAbsent(key, () {
      final c = WriteCoordinator(key: key);
      userDataRegistry.registerCoordinator(c);
      return c;
    });
  }

  Future<List<OrderItem>> hydrate(String userId) async {
    try {
      final key = keyFor(userId);
      final raw = await store.read(key);
      if (raw == null || raw.isEmpty) return [];

      final envelope = Envelope.decode(raw);
      if (envelope == null || envelope.userId != userId) return [];

      final rawList = envelope.data['orders'];
      if (rawList is! List) return [];

      final orders = <OrderItem>[];
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          final o = OrderItem.fromJson(item);
          if (o != null) orders.add(o);
        }
      }
      return orders;
    } catch (_) {
      return [];
    }
  }

  void schedulePersist(String userId, List<OrderItem> orders) {
    final coordinator = coordinatorFor(userId);
    coordinator.schedule(() async {
      final key = keyFor(userId);
      final envelope = Envelope(
        v: currentVersion,
        savedAt: DateTime.now().toUtc(),
        userId: userId,
        data: {
          'orders': orders.take(20).map((o) => o.toJson()).toList(),
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
  }
}
