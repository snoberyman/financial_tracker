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

  // Get Expenses
  Stream<List<Map<String, dynamic>>> getExpenses() {
    return _db.collection('expenses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Delete Expense
  Future<void> deleteExpense(String docId) async {
    try {
      await _db.collection('expenses').doc(docId).delete();
    } catch (e) {
      throw Exception('Error deleting expense: $e');
    }
  }
}
