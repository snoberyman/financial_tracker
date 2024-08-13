import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart'; // Import your sign-in screen

class AuthenticatedHome extends StatelessWidget {
  final String title;

  const AuthenticatedHome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While checking authentication status
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // If authenticated, show home page
          return MyHomePage(title: title);
        } else {
          // If not authenticated, redirect to sign-in screen
          return const SignInScreen();
        }
      },
    );
  }

  Future<User?> _checkAuthStatus() async {
    return FirebaseAuth.instance.currentUser;
  }
}
