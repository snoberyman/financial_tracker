import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../models/catgeory.dart';
import '../services/categories_firestore_service.dart';
import '../services/expenses_firestore_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final CategoriesFirestoreService _categoriesFirestoreService =
      CategoriesFirestoreService(); // Use the correct service

  final ExpensesFirestoreService _expensesFirestoreService =
      ExpensesFirestoreService(); // Separate service for expenses

  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Rent';
  bool _isButtonEnabled = false;
  List<Category> _categories = []; // Initially empty
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
    _fetchCategories(); // Fetch categories when the screen is initialized
  }

  void _onAmountChanged() {
    setState(() {
      _isButtonEnabled = _amountController.text.isNotEmpty;
    });
  }

  Future<void> _fetchCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final categories =
          await _categoriesFirestoreService.getCategories(user.uid);
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty) {
          _selectedCategory =
              _categories[0].name; // Set the first category as the default
        }
        _isLoading = false; // Set loading to false after fetching
      });
    }
  }

  // Method to open date picker
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

  // Method to handle the "Add" button click
  void _addExpense() async {
    if (_isButtonEnabled) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Create an Expense object
        final expense = Expense(
          id: '', // The ID will be generated by Firestore
          category: _selectedCategory,
          date: _selectedDate,
          amount: double.parse(_amountController.text),
        );

        // Create FirestoreService instance

        // Add the expense to Firestore
        await _expensesFirestoreService
            .addExpense(
          category: expense.category,
          date: expense.date,
          amount: expense.amount,
          userId: user.uid, // Pass user ID
        )
            .then((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (Route<dynamic> route) => false,
          ); // Pop the screen after adding the expense
        });
      } else {
        // Handle the case where the user is not logged in
        print('No user is logged in');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.name, // Use category.name for the value
                        child: Text(category
                            .name), // Display category.name in the dropdown
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Date Picker
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat.yMMMd().format(_selectedDate)),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Amount Text Field
                  TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Add Button
                  ElevatedButton(
                    onPressed: _isButtonEnabled ? _addExpense : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          _isButtonEnabled ? Colors.white : Colors.black54,
                      backgroundColor: _isButtonEnabled
                          ? Theme.of(context).primaryColor
                          : Colors.grey, // Font color when enabled/disabled
                    ),
                    child: const Text('Add Expense'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
