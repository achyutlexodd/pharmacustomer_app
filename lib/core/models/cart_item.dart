class CartItem {
  final String id;
  final String name;
  final String pack;
  final double price;
  int quantity;
  final bool requiresPrescription;
  final DateTime? addedAt;
  final DateTime? updatedAt;

  CartItem({
    required this.id,
    required this.name,
    required this.pack,
    required this.price,
    this.quantity = 1,
    this.requiresPrescription = false,
    this.addedAt,
    this.updatedAt,
  });

  double get total => price * quantity;
  int get unitPricePaise => (price * 100).round();

  CartItem copyWith({
    String? id,
    String? name,
    String? pack,
    double? price,
    int? quantity,
    bool? requiresPrescription,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      pack: pack ?? this.pack,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': id,
    'name': name,
    'pack': pack,
    'packSize': pack,
    'unitPricePaise': unitPricePaise,
    'quantity': quantity,
    'requiresPrescription': requiresPrescription,
    'addedAt': addedAt?.toUtc().toIso8601String(),
    'updatedAt': updatedAt?.toUtc().toIso8601String(),
  };

  static CartItem? fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final id = value['id'] ?? value['productId'];
    final name = value['name'];
    final pack = value['pack'] ?? value['packSize'] ?? '';
    final dynamic rawPrice = value['unitPricePaise'] ?? value['price'];
    final quantity = value['quantity'];

    if (id is! String || name is! String || pack is! String || quantity is! int) {
      return null;
    }

    if (quantity < 1 || quantity > 10) return null;

    double parsedPrice = 0.0;
    if (rawPrice is int) {
      if (rawPrice < 0) return null;
      parsedPrice = rawPrice / 100.0;
    } else if (rawPrice is num) {
      if (rawPrice < 0) return null;
      parsedPrice = rawPrice.toDouble();
    } else {
      return null;
    }

    final addedAtRaw = value['addedAt'];
    final updatedAtRaw = value['updatedAt'];

    return CartItem(
      id: id,
      name: name,
      pack: pack,
      price: parsedPrice,
      quantity: quantity,
      requiresPrescription: value['requiresPrescription'] == true,
      addedAt: addedAtRaw is String ? DateTime.tryParse(addedAtRaw) : null,
      updatedAt: updatedAtRaw is String ? DateTime.tryParse(updatedAtRaw) : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem &&
          other.id == id &&
          other.name == name &&
          other.pack == pack &&
          (other.price - price).abs() < 0.001 &&
          other.quantity == quantity &&
          other.requiresPrescription == requiresPrescription);

  @override
  int get hashCode => Object.hash(id, name, pack, (price * 100).round(), quantity, requiresPrescription);
}
