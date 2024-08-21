import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/budget_firestore_service.dart';
import '../services/expenses_firestore_service.dart';
import '../models/budget.dart';
import '../models/expense.dart';
import '../widgets/budget_add.dart';
import '../widgets/budget_bar_chart.dart';
import '../widgets/budget_overview.dart';
import 'budget_list_screen.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> with RouteAware {
  final BudgetFirestoreService _budgetService = BudgetFirestoreService();
  final ExpensesFirestoreService _expenseService = ExpensesFirestoreService();
  List<double> budgetData = [];
  List<double> expensesData = [];

  @override
  void initState() {
    super.initState();
    _fetchBudgets();
    _fetchExpenses();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute as PageRoute);
    }
  }

  // Unregister RouteAware
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when this page is revealed after another page is popped off
    _fetchBudgets();
    _fetchExpenses();
  }

  Future<void> _fetchBudgets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Budget> fetchedBudgets =
          await _budgetService.getBudgetsForLastFiveMonths(user.uid);

      budgetData = List.filled(6, 0.0);
      final now = DateTime.now();

      for (Budget budget in fetchedBudgets) {
        int monthDifference =
            now.month - budget.month + (now.year - budget.year) * 12;
        if (monthDifference >= 0 && monthDifference < 6) {
          budgetData[5 - monthDifference] = budget.amount;
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _fetchExpenses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      expensesData = List.filled(6, 0.0);
      final now = DateTime.now();

      for (int i = 0; i < 6; i++) {
        final date = DateTime(now.year, now.month - i, 1);
        List<Expense> expenses =
            await _expenseService.getExpensesForMonth(date, user.uid);

        double totalExpenses =
            expenses.fold(0.0, (sum, expense) => sum + expense.amount);

        expensesData[5 - i] = totalExpenses;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Monthly Budget',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            BudgetBarChart(
              budgetData: budgetData,
              expensesData: expensesData,
            ),
            const Divider(),
            const SizedBox(height: 20),
            Expanded(
              child: BudgetOverview(
                budgetData: budgetData,
                expensesData: expensesData,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AllBudgetsScreen(),
                    ));
                  },
                  child: Text('View All Budgets'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BudgetAdd(),
                    ));
                  },
                  child: Text('Add New Budget'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Create a RouteObserver to track navigation events
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
