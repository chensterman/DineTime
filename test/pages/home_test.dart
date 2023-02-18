import 'package:dinetime_mobile_mvp/firebase_options.dart';
import 'package:dinetime_mobile_mvp/pages/home/home_page/home.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../services/analyticsmock.dart';
import '../services/authmock.dart';
import '../services/databasemock.dart';
import '../services/locationmock.dart';
import '../services/storagemock.dart';
import 'pagetestbase.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final services = Services(
    clientAuth: AuthServiceMock(),
    clientLocation: LocationServiceMock(),
    clientDB: DatabaseServiceMock(),
    clientStorage: StorageServiceMock(),
    clientAnalytics: AnalyticsServiceMock(),
  );

  runApp(
    PageTestBase(
      page: Home(
        services: services,
      ),
    ),
  );
}
