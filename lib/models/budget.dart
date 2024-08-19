class Budget {
  final String id;
  final double amount;
  final int month; // 1 for January, 2 for February, etc.
  final int year;

  Budget({
    required this.id,
    required this.amount,
    required this.month,
    required this.year,
  });

  factory Budget.fromMap(String id, Map<String, dynamic> data) {
    return Budget(
      id: id,
      amount: data['amount'],
      month: data['month'],
      year: data['year'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'month': month,
      'year': year,
    };
  }
}
