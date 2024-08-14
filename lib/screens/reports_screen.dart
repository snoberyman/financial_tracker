import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null && user.displayName != null)
              Text(
                'Welcome, ${user.displayName}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (user != null && user.displayName == null)
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 40),

            // Sign Out button in the center
            Expanded(
              child: Center(
                child: Text('Reports Screen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
