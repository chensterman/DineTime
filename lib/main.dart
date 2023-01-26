import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/views/onboarding/locationpreferences.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/views/home/home.dart';
import 'package:dinetime_mobile_mvp/views/onboarding/signin.dart';
import 'package:dinetime_mobile_mvp/views/onboarding/verifyemail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'firebase_options.dart';

// // Testing code, distance should be around 1940 miles
// LocationService testServ = LocationService();
// Future<String> testDist() async {
//   GeoPoint clark = const GeoPoint(47.622400, -122.343270);
//   GeoPoint test =
//       await testServ.addressToGeopoint('26500 Wixom Rd, Novi, MI 48374');
//   double testLat = test.latitude;
//   double testLong = test.longitude;
//   print('Test Geocode: $testLat and $testLong');
//   double dist = testServ.distanceBetweenTwoPoints(clark, test);
//   return 'Test Geo Dist: $dist';
// }

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Testing distance calculator
  // print(await (testDist()));
  // GeoPoint? test = await LocationService().getLocationData();
  // print(test);
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
      const Duration(seconds: 1),
      () => {
        // Route to the authentication checker widget
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthStateCheck()),
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
  AuthStateCheck({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(context) {
    return StreamBuilder<User?>(
      // Stream keeps track of user events
      stream: _auth.streamUserState(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!;
          if (user.emailVerified) {
            // If logged in and email is verified, run location permissions check
            return LocationPermissionStateCheck();
          } else {
            // If logged in and email is not verified, route to onboarding
            // process, starting with the email verification page
            return VerifyEmail(email: user.email!);
          }
        } else {
          // If not logged in, route to sign in page
          return const SignIn();
        }
      }),
    );
  }
}

// Widget that checks the state of location permission enablement
class LocationPermissionStateCheck extends StatelessWidget {
  LocationPermissionStateCheck({super.key});
  final LocationService _location = LocationService();

  @override
  Widget build(context) {
    return StreamBuilder<PermissionStatus>(
      // Stream keeps track of the status of location permissions on the device
      stream: _location.getLocationPermissionStatus(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          PermissionStatus locationPermission = snapshot.data!;
          if (locationPermission == PermissionStatus.denied) {
            // If location permissions are denied, route to location preferences
            // page from onboarding section
            return const LocationPreferences();
          } else {
            // If location permissions are accepted, route to FYF homepage
            return const Home();
          }
        } else {
          // Loading screen if location permissions have not been returned yet
          return const LoadingScreen();
        }
      }),
    );
  }
}
