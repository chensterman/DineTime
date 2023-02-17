import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth.dart';
import 'services/location.dart';
import 'pages/root/start_page/start.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
    clientAuth: AuthServiceApp(),
    clientLocation: LocationServiceApp(),
    clientDB: DatabaseServiceApp(),
    clientStorage: StorageServiceApp(),
    clientAnalytics: AnalyticsServiceApp(),
  ));
}

// The base widget for the app using the MatieralApp class
class MyApp extends StatelessWidget {
  final AuthService clientAuth;
  final LocationService clientLocation;
  final DatabaseService clientDB;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const MyApp({
    super.key,
    required this.clientAuth,
    required this.clientLocation,
    required this.clientDB,
    required this.clientStorage,
    required this.clientAnalytics,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            value: clientAuth.streamUserState(), initialData: null),
        StreamProvider<PermissionStatus>.value(
            value: clientLocation.getLocationPermissionStatus(),
            initialData: PermissionStatus.granted),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DineTime Demo',
        theme: ThemeData(
          colorScheme: dineTimeColorScheme,
          textTheme: dineTimeTypography,
        ),
        home: Start(
          clientAuth: clientAuth,
          clientLocation: clientLocation,
          clientDB: clientDB,
          clientStorage: clientStorage,
          clientAnalytics: clientAnalytics,
        ),
      ),
    );
  }
}
