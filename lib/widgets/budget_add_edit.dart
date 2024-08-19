import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/budget.dart';

class BudgetAddEdit extends StatefulWidget {
  final Budget? budget;

  const BudgetAddEdit({Key? key, this.budget}) : super(key: key);

  @override
  _BudgetAddEditState createState() => _BudgetAddEditState();
}

class _BudgetAddEditState extends State<BudgetAddEdit> {
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _amountController.text = widget.budget!.amount.toString();
      _selectedDate = DateTime(widget.budget!.year, widget.budget!.month);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveBudget() {
    // Implement the save logic, including Firestore updates
  }

  void _deleteBudget() {
    // Implement the delete logic
  }

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
              onPressed: _saveBudget,
              child: const Text('Save Budget'),
            ),
            if (widget.budget != null)
              TextButton(
                onPressed: _deleteBudget,
                child: const Text(
                  'Delete Budget',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
