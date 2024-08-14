import 'package:flutter/material.dart';

import '../models/Expense.dart';

class AllExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final controller = ScrollController();
  final Function(int) onDelete; // Callback function for delete action

// Add a height parameter

  AllExpenseList({
    super.key,
    required this.expenses,
    required this.onDelete, // Required parameter for delete callback
  });

  @override
  Widget build(BuildContext context) {
    // If the expenses list is empty, show a message
    if (expenses.isEmpty) {
      return const Center(
        child: Text(
          'No records found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: controller,
            child: ListView.builder(
                controller: controller,
                itemCount: expenses.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 8.0),
                    child: Row(
                      children: [
                        // Date
                        Text(
                          '${expenses[index].date.day}/${expenses[index].date.month}/${expenses[index].date.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 10),

                        // Name of Category (with flexibility)
                        Expanded(
                          flex: 3,
                          child: Text(
                            expenses[index].category,
                            style: const TextStyle(fontSize: 18),
                            overflow: TextOverflow
                                .ellipsis, // Ensures text doesn't overflow
                          ),
                        ),

                        // Amount
                        Expanded(
                          flex: 2,
                          child: Text(
                            '\$${expenses[index].amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                            textAlign:
                                TextAlign.right, // Aligns text to the right
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Delete Icon
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.red,
                          onPressed: () =>
                              onDelete(index), // Call the delete callback
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
