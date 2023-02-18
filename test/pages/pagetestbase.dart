// The base widget for the app using the MatieralApp class
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/analyticsmock.dart';
import '../services/authmock.dart';
import '../services/databasemock.dart';
import '../services/locationmock.dart';
import '../services/storagemock.dart';

class PageTestBase extends StatelessWidget {
  final Widget page;
  const PageTestBase({
    super.key,
    required this.page,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) {
          return Services(
            clientAuth: AuthServiceMock(),
            clientLocation: LocationServiceMock(),
            clientDB: DatabaseServiceMock(),
            clientStorage: StorageServiceMock(),
            clientAnalytics: AnalyticsServiceMock(),
          );
        }),
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
