import 'package:dinetime_mobile_mvp/firebase_options.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/root/start_page/start.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'services/analyticsmock.dart';
import 'services/authmock.dart';
import 'services/databasemock.dart';
import 'services/locationmock.dart';
import 'services/storagemock.dart';

// Main function starts the app
void main() async {
  // Required initialization functions to be run for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MyAppTest(
      page: const Start(),
    ),
  );
}

class MyAppTest extends StatelessWidget {
  final Widget page;
  MyAppTest({
    super.key,
    required this.page,
  });

  final services = Services(
    clientAuth: AuthServiceMock(),
    clientLocation: LocationServiceMock(),
    clientDB: DatabaseServiceMock(),
    clientStorage: StorageServiceMock(),
    clientAnalytics: AnalyticsServiceMock(),
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
        theme: ThemeData(
          colorScheme: dineTimeColorScheme,
          textTheme: dineTimeTypography,
        ),
        home: page,
      ),
    );
  }
}
