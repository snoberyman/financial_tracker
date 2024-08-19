import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../widgets/budget_add_edit.dart';
import '../widgets/budget_bar_chart.dart';
import '../widgets/budget_overview.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder data

    // montlhy budgetand expnese  from five months ago to current month
    List<double> budgetData = [0, 1200, 1300, 1400, 1500, 1600];
    List<double> expensesData = [0, 1250, 1350, 1450, 1550, 1650];
    List<Budget> budgets = []; // Fetch from Firestore

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align text to the right
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
            // Bar Chart
            BudgetBarChart(
              budgetData: budgetData,
              expensesData: expensesData,
            ),

            Divider(),
            SizedBox(height: 20),
            // Add Budget Section

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BudgetAddEdit(),
                ));
              },
              child: Text('Add New Budget'),
            ),
            const SizedBox(
              height: 20,
            ),
            // Budget Overview
            Expanded(
              child: BudgetOverview(budgets: budgets, expenses: expensesData),
            ),
          ],
        ),
      ),
    );
  }
}
