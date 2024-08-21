import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../models/budget.dart';
import '../services/budget_firestore_service.dart';

class BudgetAdd extends StatefulWidget {
  final Budget? budget;

  const BudgetAdd({Key? key, this.budget}) : super(key: key);

  @override
  _BudgetAddState createState() => _BudgetAddState();
}

class _BudgetAddState extends State<BudgetAdd> {
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late BudgetFirestoreService _budgetService;
  bool _isAmountValid = false;

  @override
  void initState() {
    super.initState();
    _budgetService = BudgetFirestoreService(); // Initialize your service

    if (widget.budget != null) {
      _amountController.text = widget.budget!.amount.toString();
      _selectedDate = DateTime(widget.budget!.year, widget.budget!.month);
      _isAmountValid = _amountController.text.isNotEmpty;
    }

    _amountController.addListener(() {
      setState(() {
        _isAmountValid = _amountController.text.isNotEmpty;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveBudget() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final user = FirebaseAuth.instance.currentUser;
    ; // Replace with actual user ID

    if (user == null) {
      // Handle the case where no user is signed in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is signed in')),
      );
      return;
    }

    final userId = user.uid;
    if (widget.budget == null) {
      await _budgetService.addBudget(
        amount: amount,
        month: _selectedDate.month,
        year: _selectedDate.year,
        userId: userId,
      );
    } else {
      // Implement update logic here if needed
    }

    Navigator.of(context).pop();
  }

  // Future<void> _deleteBudget() async {
  //   final user = FirebaseAuth.instance.currentUser; // Get current user

  //   if (user == null) {
  //     // Handle the case where no user is signed in
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('No user is signed in')),
  //     );
  //     return;
  //   }

  //   final userId = user.uid; // Use the current user's ID
  //   if (widget.budget != null) {
  //     await _budgetService.deleteBudget(userId, widget.budget!.id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget == null ? 'Add Budget' : 'Edit Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat.yMMMM().format(_selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isAmountValid ? _saveBudget : null,
              child: const Text('Save Budget'),
            ),
            // if (widget.budget != null)
            //   TextButton(
            //     onPressed: _deleteBudget,
            //     child: const Text(
            //       'Delete Budget',
            //       style: TextStyle(color: Colors.red),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
