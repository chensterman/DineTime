import 'dart:async';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/views/fyf.dart';
import 'package:dinetime_mobile_mvp/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Startup the base MyApp widget
  runApp(const MyApp());
}

// The base widget for the app using the MatieralApp class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DineTime Demo',
      theme: ThemeData(
        colorScheme: dineTimeColorScheme,
        textTheme: dineTimeTypography,
      ),
      home: const Start(),
    );
  }
}

// Start page with a 5 second viewing of the DineTime logo
class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(context) {
    // Timer to display DineTime logo before routing to AuthStateCheck
    Timer(
      const Duration(seconds: 5),
      () => {
        // Route to the authentication checker widget
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AuthStateCheck()),
        )
      },
    );
    // DineTime logo displayed
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Image(
          image: AssetImage('lib/assets/dinetime-combo-white.png'),
        ),
      ),
    );
  }
}

// Widget that checks the state of Firebase authentication
class AuthStateCheck extends StatelessWidget {
  const AuthStateCheck({super.key});

  @override
  Widget build(context) {
    return StreamBuilder<User?>(
      // Stream keeps track of user events
      stream: AuthService().user(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          // If logged in, route to FYF page
          return const FindYourFood();
        } else {
          // If not logged in, route to sign in page
          return const SignIn();
        }
      }),
    );
  }
}
