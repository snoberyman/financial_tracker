import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpensesFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to add an expense
  Future<void> addExpense({
    required String category,
    required DateTime date,
    required double amount,
    required String userId,
  }) async {
    try {
      await _db.collection('users').doc(userId).collection('expenses').add({
        'category': category,
        'date': date,
        'amount': amount,
      });
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

// Method to get expenses for a user for a single month
  Future<List<Expense>> getExpensesForMonth(
      DateTime month, String userId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .where('date',
              isGreaterThanOrEqualTo: DateTime(month.year, month.month, 1))
          .where('date',
              isLessThanOrEqualTo: DateTime(month.year, month.month + 1, 0))
          .get();

      return querySnapshot.docs.map((doc) {
        return Expense(
          id: doc.id,
          category: doc['category'],
          date: (doc['date'] as Timestamp).toDate(),
          amount: doc['amount'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Method to delete an expense by its document ID
  Future<void> deleteExpense(String userId, String expenseId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

// Display the categories in a ListView.builder with reorderable logic.
}
