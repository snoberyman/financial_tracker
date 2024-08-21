import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget.dart';

class BudgetFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to add a budget
  Future<void> addBudget({
    required double amount,
    required int month,
    required int year,
    required String userId,
  }) async {
    try {
      await _db.collection('users').doc(userId).collection('budgets').add({
        'amount': amount,
        'month': month,
        'year': year,
      });
    } catch (e) {
      print('Error adding budget: $e');
    }
  }

  // Method to get budgets for the last five months including the current month
  Future<List<Budget>> getBudgetsForLastFiveMonths(String userId) async {
    try {
      final now = DateTime.now();
      final firstMonth = DateTime(now.year, now.month - 4, 1);
      final budgets = <Budget>[];

      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .where('year', isGreaterThanOrEqualTo: firstMonth.year)
          .get();

      for (var doc in querySnapshot.docs) {
        final budget =
            Budget.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        // Filter budgets for the last five months
        final budgetDate = DateTime(budget.year, budget.month);
        if (budgetDate.isAfter(firstMonth) ||
            budgetDate.isAtSameMomentAs(firstMonth)) {
          budgets.add(budget);
        }
      }

      return budgets;
    } catch (e) {
      print('Error fetching budgets: $e');
      return [];
    }
  }

  // Method to fetch all budgets for a user
  Future<List<Budget>> getAllBudgets(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .orderBy('year')
          .orderBy('month')
          .get();

      return querySnapshot.docs.map((doc) {
        return Budget(
          id: doc.id,
          amount: doc['amount'],
          month: doc['month'],
          year: doc['year'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching budgets: $e');
      return [];
    }
  }

  // Method to get budget for a specific month
  Future<Budget?> getBudgetForMonth(int month, int year, String userId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .where('month', isEqualTo: month)
          .where('year', isEqualTo: year)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Budget.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching budget: $e');
      return null;
    }
  }

  // Method to delete a budget by its document ID
  Future<void> deleteBudget(String userId, String budgetId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc(budgetId)
          .delete();
    } catch (e) {
      print('Error deleting budget: $e');
    }
  }
}
