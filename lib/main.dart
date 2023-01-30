import 'dart:async';
import 'package:dinetime_mobile_mvp/ui/onboarding/locationpreferences.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/signup_page/signup.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/ui/home/home.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/verifyemail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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

// Start page with a 5 second viewing of the DineTime logo
class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(context) {
    // Timer to display DineTime logo before routing to AuthStateCheck
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RoutingProvider()));
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

class RoutingProvider extends StatelessWidget {
  const RoutingProvider({super.key});

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            value: AuthService().streamUserState(), initialData: null),
        StreamProvider<PermissionStatus>.value(
            value: LocationService().getLocationPermissionStatus(),
            initialData: PermissionStatus.granted),
      ],
      child: const RoutingLogic(),
    );
  }
}

class RoutingLogic extends StatelessWidget {
  const RoutingLogic({super.key});

  @override
  Widget build(context) {
    final user = Provider.of<User?>(context);
    final locationPermission = Provider.of<PermissionStatus>(context);
    if (user == null) {
      return const SignUp();
    } else {
      if (user.emailVerified) {
        if (locationPermission == PermissionStatus.denied) {
          return const LocationPreferences();
        } else {
          return const Home();
        }
      } else {
        return VerifyEmail(email: user.email!);
      }
    }
  }
}
