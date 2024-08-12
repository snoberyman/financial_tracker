import 'package:flutter/material.dart';

import '../widgets/total_expense_list.dart';
import '../widgets/all_expense_list.dart';
import 'add_expense_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // pass title from partent widget
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // state
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Rent', 'amount': 1550.50, 'date': DateTime(2024, 8, 1)},
    {'name': 'Grocery', 'amount': 500.00, 'date': DateTime(2024, 8, 15)},
    {'name': 'Eating-out', 'amount': 75.25, 'date': DateTime(2024, 9, 1)},
    {'name': 'Bills', 'amount': 40.00, 'date': DateTime(2024, 9, 1)},
    {'name': 'Miscellanious', 'amount': 95.75, 'date': DateTime(2024, 8, 1)},
    {'name': 'Miscellanious', 'amount': 90.75, 'date': DateTime(2024, 9, 1)},
  ];

  // Example current month
  DateTime _currentMonth = DateTime.now();

  // Function to calculate total expenses for the selected month
  double get _totalExpense {
    return _filteredExpenses.fold(0.0, (sum, item) => sum + item['amount']);
  }

  Map<String, double> get _groupedExpenses {
    Map<String, double> groupedExpenses = {};

    for (var expense in _filteredExpenses) {
      String category = expense['name'];
      double amount = expense['amount'];

      if (groupedExpenses.containsKey(category)) {
        groupedExpenses[category] = groupedExpenses[category]! + amount;
      } else {
        groupedExpenses[category] = amount;
      }
    }

    return groupedExpenses;
  }

  // Function to get the filtered list of expenses based on the selected month
  List<Map<String, dynamic>> get _filteredExpenses {
    return _categories.where((expense) {
      return expense['date']?.month == _currentMonth.month &&
          expense['date'].year == _currentMonth.year;
    }).toList();
  }

  // Function to go to the previous month
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  // Function to go to the next month
  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _navigateToAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Details'),
          ],
        ),
      ),
      body: Padding(
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
                    expenses: _filteredExpenses,
                    onDelete: (index) {
                      setState(() {
                        _filteredExpenses.removeAt(
                            index); // Remove the expense from the list
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // add expnese button
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        tooltip: 'add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
