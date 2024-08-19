import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'budget_add_edit.dart';
import '../models/budget.dart';

class BudgetOverview extends StatelessWidget {
  final List<Budget> budgets;
  final List<double> expenses;

  const BudgetOverview(
      {Key? key, required this.budgets, required this.expenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (ctx, index) {
        final budget = budgets[index];
        final expense = expenses[index];
        final difference = budget.amount - expense;

        return ListTile(
          title: Text(
              DateFormat.yMMMM().format(DateTime(budget.year, budget.month))),
          subtitle: Text(
              'Budget: \$${budget.amount.toStringAsFixed(2)}, Expenses: \$${expense.toStringAsFixed(2)}'),
          trailing: Text(
            '\$${difference.toStringAsFixed(2)}',
            style:
                TextStyle(color: difference >= 0 ? Colors.green : Colors.red),
          ),
          onTap: () {
            // Navigate to edit screen
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BudgetAddEdit(budget: budget),
            ));
          },
        );
      },
    );
  }
}
