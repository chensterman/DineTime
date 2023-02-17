import 'package:dinetime_mobile_mvp/firebase_options.dart';
import 'package:dinetime_mobile_mvp/ui/home/findyourfood_page/findyourfood.dart';
import 'package:dinetime_mobile_mvp/ui/home/home_page/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pagetestbase.dart';
import 'services/authmock.dart';
import 'services/databasemock.dart';
import 'services/locationmock.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    PageTestBase(
      page: Home(
        clientDB: DatabaseServiceMock(),
        clientAuth: AuthServiceMock(),
        clientLocation: LocationServiceMock(),
      ),
    ),
  );
}
