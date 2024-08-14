import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddExpenseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60.0, // Adjust width for square shape
        height: 60.0, // Adjust height for square shape
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle, // Square shape
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
              12.0), // Rounded corners for better aesthetics
        ),
        child: const Icon(
          Icons.add,
          size: 40.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
