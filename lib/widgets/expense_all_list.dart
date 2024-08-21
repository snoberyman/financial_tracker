import 'package:flutter/material.dart';

import '../models/expense.dart';

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
    // delete confirmation box
    void showDeleteConfirmation(BuildContext context, int index) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                onDelete(index); // Call the delete callback
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

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
                            style: const TextStyle(fontSize: 16),
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
                              showDeleteConfirmation(context, index),
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
