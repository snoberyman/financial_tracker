import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Expense.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to add an expense
  Future<void> addExpense({
    required String category,
    required DateTime date,
    required double amount,
    required String userId,
  }) async {
    try {
      await _db.collection('Expenses').add({
        'category': category,
        'date': date,
        'amount': amount,
        'userId': userId,
      });
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  Future<List<Expense>> getExpensesForMonth(
      DateTime month, String userId) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);
      final snapshot = await _db
          .collection('Expenses')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      return snapshot.docs
          .map((doc) =>
              Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Method to delete an expense by its document ID
  Future<void> deleteExpense(String documentId) async {
    try {
      await _db.collection('Expenses').doc(documentId).delete();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }
}
