import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/budget.dart';
import '../services/budget_firestore_service.dart';

class AllBudgetsScreen extends StatefulWidget {
  @override
  _AllBudgetsScreenState createState() => _AllBudgetsScreenState();
}

class _AllBudgetsScreenState extends State<AllBudgetsScreen> {
  final BudgetFirestoreService _budgetService = BudgetFirestoreService();
  List<Budget> _budgets = [];

  @override
  void initState() {
    super.initState();
    _fetchAllBudgets();
  }

  Future<void> _fetchAllBudgets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _budgets = await _budgetService.getAllBudgets(user.uid);
      setState(() {});
    }
  }

  Future<void> _deleteBudget(String budgetId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _budgetService.deleteBudget(user.uid, budgetId);
      _fetchAllBudgets(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Budgets'),
      ),
      body: ListView.builder(
        itemCount: _budgets.length,
        itemBuilder: (context, index) {
          final budget = _budgets[index];
          return ListTile(
            title: Text('${budget.month}/${budget.year}'),
            subtitle: Text('\$${budget.amount.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteBudget(budget.id);
              },
            ),
          );
        },
      ),
    );
  }
}
