import 'package:dinetime_mobile_mvp/firebase_options.dart';
import 'package:dinetime_mobile_mvp/ui/home/findyourfood_page/findyourfood.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pagetestbase.dart';
import 'services/authmock.dart';
import 'services/databasemock.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    PageTestBase(
      page: FindYourFood(
        clientDB: DatabaseServiceMock(),
        clientAuth: AuthServiceMock(),
      ),
    ),
  );
}
