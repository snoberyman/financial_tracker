import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/sign_up_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/auth_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Tracker',
      // app theme data
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 191, 28)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) =>
            const AuthenticatedHome(title: 'Financial Tracker'),
      },
      // home screen
    );
  }
}
