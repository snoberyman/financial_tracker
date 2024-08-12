import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to add an expense
  Future<void> addExpense({
    required String category,
    required DateTime date,
    required double amount,
  }) async {
    try {
      await _db.collection('Expenses').add({
        'category': category,
        'date': date,
        'amount': amount,
      });
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  // Method to fetch expenses for a specific month
  Future<List<Map<String, dynamic>>> getExpensesForMonth(DateTime month) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Expenses')
          .where('date',
              isGreaterThanOrEqualTo: DateTime(month.year, month.month, 1))
          .where('date', isLessThan: DateTime(month.year, month.month + 1, 1))
          .get();

      List<Map<String, dynamic>> expenses = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID
          'name': doc['category'],
          'amount': doc['amount'],
          'date': (doc['date'] as Timestamp).toDate(),
        };
      }).toList();

      return expenses;
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
