/// Value type representing monetary amounts in integer paise (1 Rupee = 100 Paise).
/// Avoids IEEE-754 floating point rounding errors during math and persistence.
class Money implements Comparable<Money> {
  final int paise;

  const Money.fromPaise(this.paise);

  factory Money.fromRupees(num rupees) => Money.fromPaise((rupees * 100).round());

  static const Money zero = Money.fromPaise(0);

  double get inRupees => paise / 100.0;

  Money operator +(Money other) => Money.fromPaise(paise + other.paise);

  Money operator -(Money other) => Money.fromPaise(paise - other.paise);

  Money operator *(num multiplier) => Money.fromPaise((paise * multiplier).round());

  @override
  int compareTo(Money other) => paise.compareTo(other.paise);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Money && other.paise == paise);

  @override
  int get hashCode => paise.hashCode;

  /// Formats in Indian Rupee format, e.g. "₹2,459" or "₹148.60"
  String format({bool includeDecimalsIfInteger = false}) {
    final isNegative = paise < 0;
    final absPaise = paise.abs();
    final wholeRupees = absPaise ~/ 100;
    final remainingPaise = absPaise % 100;

    final buffer = StringBuffer(isNegative ? '-₹' : '₹');
    buffer.write(wholeRupees.toString());

    if (remainingPaise > 0 || includeDecimalsIfInteger) {
      buffer.write('.${remainingPaise.toString().padLeft(2, '0')}');
    }
    return buffer.toString();
  }

  @override
  String toString() => format(includeDecimalsIfInteger: true);
}
