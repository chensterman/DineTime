import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/firebase_options.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/root/start_page/start.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/notifications.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'services/analyticsmock.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Required initialization for Stripe to run
  Stripe.publishableKey =
      "pk_live_51MMR2pAmON0LxpMBJ2DoHfvN0RwY6aOESiAjTzmuXX3Y6H5SPNy61bX7bUNebIi7afsTkpu5BZCXDRg3bDeuIwsC00qilbuwgl";
  Stripe.merchantIdentifier = 'DineTime';
  await Stripe.instance.applySettings();
  await _configureFirebaseAuth();
  await _configureFirebaseStorage();
  _configureFirebaseFirestore();
  _configureFirebaseFunctions();
  runApp(
    MyAppTest(
      page: const Start(),
    ),
  );
}

void _configureFirebaseFunctions() {
  var host = "localhost";
  var port = 5001;
  FirebaseFunctions.instance.useFunctionsEmulator(host, port);
  debugPrint('Using Firebase Functions emulator on: $host:$port');
}

Future<void> _configureFirebaseAuth() async {
  var host = "localhost";
  var port = 9099;
  await FirebaseAuth.instance.useAuthEmulator(host, port);
  debugPrint('Using Firebase Auth emulator on: $host:$port');
}

Future<void> _configureFirebaseStorage() async {
  var host = "localhost";
  var port = 9199;
  await FirebaseStorage.instance.useStorageEmulator(host, port);
  debugPrint('Using Firebase Storage emulator on: $host:$port');
}

void _configureFirebaseFirestore() {
  var host = "localhost";
  var port = 5002;
  /* 
  NO FUCKING CLUE WHY TUTORIALS SAY TO INCLUDE THE SHIT BELOW
  IT JUST CRASHES THE CONNECTION TO THE IOS EMULATOR AND TOOK ME
  TWO FUCKING HOURS TO FIGURE OUT TO REMOVE THE CODE
  */
  // FirebaseFirestore.instance.settings = Settings(
  //   host: '$host:$port',
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );
  FirebaseFirestore.instance.useFirestoreEmulator(host, port);
  debugPrint('Using Firebase Firestore emulator on: $host:$port');
}

class MyAppTest extends StatelessWidget {
  final Widget page;
  MyAppTest({
    super.key,
    required this.page,
  });

  final services = Services(
    clientAuth: AuthServiceApp(),
    clientLocation: LocationServiceApp(),
    clientDB: DatabaseServiceApp(),
    clientStorage: StorageServiceApp(),
    clientAnalytics: AnalyticsServiceMock(),
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DineTime Demo',
        home: page,
      ),
    );
  }
}
