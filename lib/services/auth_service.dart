import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Update display name
      if (user != null) {
        await user.updateDisplayName(name);
        await _createInitialCategories();
      }

      return user;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if user is authenticated
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // add initial collection of categories
  Future<void> _createInitialCategories() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    final categoriesRef =
        firestore.collection('users').doc(user.uid).collection('categories');
    final snapshot = await categoriesRef.get();

    if (snapshot.docs.isEmpty) {
      final predefinedCategories = [
        {'name': 'Rent', 'order': 1},
        {'name': 'Grocery', 'order': 2},
        {'name': 'Eating out', 'order': 3},
        {'name': 'Bills', 'order': 4},
        {'name': 'Transportation', 'order': 5},
        {'name': 'Entertainment', 'order': 6},
        {'name': 'Household', 'order': 7},
        {'name': 'Clothes', 'order': 8},
        {'name': 'Charity', 'order': 9},
        {'name': 'Other', 'order': 10},
        // Add more categories as needed
      ];

      for (var category in predefinedCategories) {
        await categoriesRef.add(category);
      }
    }
  }
}
