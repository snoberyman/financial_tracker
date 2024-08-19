import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String category;
  final DateTime date;
  final double amount;
  // description
  // payment method
  // location
  // recuring

  Expense({
    required this.id,
    required this.category,
    required this.date,
    required this.amount,
  });

  factory Expense.fromMap(String id, Map<String, dynamic> data) {
    return Expense(
      id: id,
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      amount: data['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'date': date,
      'amount': amount,
    };
  }
}
