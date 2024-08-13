import 'package:flutter/material.dart';

class TotalExpenseList extends StatelessWidget {
  const TotalExpenseList({
    super.key,
    required this.groupedExpenses,
    required this.totalExpense,
  });

  final Map<String, double> groupedExpenses;
  final double totalExpense;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expense Categories
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.50,
          child: ListView.builder(
            itemCount: groupedExpenses.length,
            itemBuilder: (ctx, index) {
              String category = groupedExpenses.keys.elementAt(index);
              double amount = groupedExpenses[category]!;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expense Name
                    Text(
                      category,
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Amount
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(),
        // Total Expense Row
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalExpense.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
