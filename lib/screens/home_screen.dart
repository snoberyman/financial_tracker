import 'package:financial_tracker/models/Expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/total_expense_list.dart';
import '../widgets/all_expense_list.dart';
import 'add_expense_screen.dart';
import '../services/firestore_service.dart';
import 'settings_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final FirestoreService _firestoreService = FirestoreService();
  List<Expense> _expenses = [];
  DateTime _currentMonth = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchExpenses();
  }

  void _fetchExpenses() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Expense> expenses =
          await _firestoreService.getExpensesForMonth(_currentMonth, user.uid);

      setState(() {
        _expenses = expenses; // Update with list of Expense objects
        _isLoading = false; // End loading
      });
    } else {
      setState(() {
        _isLoading = false; // End loading if no user
      });
      // Handle the case where no user is logged in
      print('No user is logged in');
    }
  }

  void _deleteExpense(int index) async {
    String documentId = _expenses[index].id;
    await _firestoreService.deleteExpense(documentId);
    _fetchExpenses(); // Refresh the list after deletion
  }

  double get _totalExpense {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  // sum total expenses
  Map<String, double> get _groupedExpenses {
    Map<String, double> groupedExpenses = {};

    for (var expense in _expenses) {
      String category = expense.category;
      double amount = expense.amount;

      if (groupedExpenses.containsKey(category)) {
        groupedExpenses[category] = groupedExpenses[category]! + amount;
      } else {
        groupedExpenses[category] = amount;
      }
    }

    return groupedExpenses;
  }

  // select mont navigator
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _fetchExpenses();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _fetchExpenses();
    });
  }

  void _navigateToAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    ).then((_) => _fetchExpenses()); // Fetch expenses after adding a new one
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings, // Navigate to settings screen
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Details'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Month Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        '${_currentMonth.month}/${_currentMonth.year}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tabs Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // First Tab: Overview with total_expense_list
                        TotalExpenseList(
                          groupedExpenses: _groupedExpenses,
                          totalExpense: _totalExpense,
                        ),

                        // Second Tab: Monthly Details with all expenses
                        AllExpenseList(
                          expenses: _expenses,
                          onDelete: _deleteExpense,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

      // Add Expense button
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
