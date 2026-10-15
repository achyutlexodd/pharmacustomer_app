class CartItem {
  final String id;
  final String name;
  final String pack;
  final double price;
  int quantity;
  final bool requiresPrescription;

  CartItem({
    required this.id,
    required this.name,
    required this.pack,
    required this.price,
    this.quantity = 1,
    this.requiresPrescription = false,
  });

  double get total => price * quantity;

  Map<String, Object> toJson() => {
    'id': id, 'name': name, 'pack': pack,
    'unitPricePaise': (price * 100).round(), 'quantity': quantity,
    'requiresPrescription': requiresPrescription,
  };

  static CartItem? fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final id = value['id'];
    final name = value['name'];
    final pack = value['pack'];
    final price = value['unitPricePaise'];
    final quantity = value['quantity'];
    if (id is! String || name is! String || pack is! String || price is! int || price < 0 || quantity is! int || quantity < 1 || quantity > 10) return null;
    return CartItem(id: id, name: name, pack: pack, price: price / 100, quantity: quantity, requiresPrescription: value['requiresPrescription'] == true);
  }
}
