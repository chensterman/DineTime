import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/notifications.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth.dart';
import 'services/location.dart';
import 'pages/root/start_page/start.dart';
import 'services/services.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
}

// The base widget for the app using the MatieralApp class
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  final services = Services(
    clientAuth: AuthServiceApp(),
    clientLocation: LocationServiceApp(),
    clientDB: DatabaseServiceApp(),
    clientStorage: StorageServiceApp(),
    clientAnalytics: AnalyticsServiceApp(),
    clientNotifications: NotificationsServiceApp(),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) {
          return services;
        }),
        StreamProvider<UserDT?>.value(
            value: services.clientAuth.streamUserState(), initialData: null),
        StreamProvider<PermissionStatus>.value(
            value: services.clientLocation.getLocationPermissionStatus(),
            initialData: PermissionStatus.granted),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DineTime Demo',
        home: Start(),
      ),
    );
  }
}
