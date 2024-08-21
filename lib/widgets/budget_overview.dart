import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetOverview extends StatelessWidget {
  final List<double> budgetData;
  final List<double> expensesData;

  const BudgetOverview(
      {Key? key, required this.budgetData, required this.expensesData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: budgetData.length,
      itemBuilder: (ctx, index) {
        // Reverse the index to display months in reverse order
        final reverseIndex = budgetData.length - 1 - index;

        final budgetAmount = budgetData[reverseIndex];
        final expenseAmount = expensesData[reverseIndex];
        final difference = budgetAmount - expenseAmount;

        // Calculate the date for the current index
        final now = DateTime.now();
        final month = now.month - index;
        final year = now.year - ((month < 1) ? 1 : 0);
        final adjustedMonth = month < 1 ? month + 12 : month;

        return ListTile(
          title: Text(DateFormat.yMMMM().format(DateTime(year, adjustedMonth))),
          subtitle: Text(
              'Budget: \$${budgetAmount.toStringAsFixed(2)}, Expenses: \$${expenseAmount.toStringAsFixed(2)}'),
          trailing: Text(
            '\$${difference.toStringAsFixed(2)}',
            style:
                TextStyle(color: difference >= 0 ? Colors.green : Colors.red),
          ),
        );
      },
    );
  }
}
