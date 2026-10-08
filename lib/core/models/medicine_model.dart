class Medicine {
  final String name;
  final String description;
  final String price;
  final String mrp;
  final String discount;
  final String badge;
  final bool requiresPrescription;
  final String? deliveryNote;
  final String? tag; // e.g. "Strip of 15 tablets"

  const Medicine({
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.badge,
    required this.requiresPrescription,
    this.deliveryNote,
    this.tag,
  });
}
