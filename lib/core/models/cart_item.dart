class CartItem {
  final String id;
  final String name;
  final String pack;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.pack,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}
