import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/root/start_page/start.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
