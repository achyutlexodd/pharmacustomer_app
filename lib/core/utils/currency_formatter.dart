/// Formats a numeric amount as an Indian Rupee string.
///
/// Examples:
///   formatRupee(485)      → '₹485.00'
///   formatRupee(1149.5)   → '₹1,149.50'
String formatRupee(num amount) {
  // Split into integer and decimal parts
  final parts = amount.toStringAsFixed(2).split('.');
  final intPart = _addIndianCommas(parts[0]);
  return '₹$intPart.${parts[1]}';
}

/// Adds Indian-style comma separators (last 3 digits, then every 2).
String _addIndianCommas(String s) {
  if (s.length <= 3) return s;
  final last3 = s.substring(s.length - 3);
  final rest = s.substring(0, s.length - 3);
  final buffer = StringBuffer();
  for (var i = 0; i < rest.length; i++) {
    if (i > 0 && (rest.length - i) % 2 == 0) buffer.write(',');
    buffer.write(rest[i]);
  }
  return '${buffer.toString()},$last3';
}
