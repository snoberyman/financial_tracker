import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/add_expense_btn.dart';

import 'home_screen.dart';
import 'categories_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'add_expense_screen.dart';

class AuthenticatedHome extends StatefulWidget {
  final String title;

  const AuthenticatedHome({super.key, required this.title});

  @override
  _AuthenticatedHomeState createState() => _AuthenticatedHomeState();
}

class _AuthenticatedHomeState extends State<AuthenticatedHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CategoriesScreen(),
    const Placeholder(), // Placeholder for the Add Expense item
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If user is not authenticated, redirect to sign-in screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/signin');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Add Expense
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
            ).then((_) {
              // Optionally refresh or handle state after returning
            });
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 25, // Adjust this value as needed
              child: Icon(
                Icons.add_circle,
                color: Color.fromARGB(255, 255, 191, 28),
                size: 45,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context)
            .colorScheme
            .primary, // Set the color for selected item
        unselectedItemColor: Colors.grey, // Set the color for unselected items
      ),
    );
  }
}
