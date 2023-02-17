import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/widgets/locationpreferences_button.dart';
import 'package:flutter/material.dart';

// Page to enable location settings
class LocationPreferencesLayout extends StatelessWidget {
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final LocationService clientLocation;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const LocationPreferencesLayout({
    Key? key,
    required this.clientAuth,
    required this.clientDB,
    required this.clientLocation,
    required this.clientStorage,
    required this.clientAnalytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const ProgressBar(percentCompletion: 0.8),
                const SizedBox(height: 60.0),
                const Image(
                  image: AssetImage('lib/assets/location.png'),
                ),
                const SizedBox(height: 40.0),
                Text(
                  "Location",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  "preferences",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Location services must be enabled",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  "in order to use DineTime",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "DineTime uses your location to ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "help you find local restaurants and pop-ups ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "around your area",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 60.0),
                LocationPreferencesButton(
                  clientAuth: clientAuth,
                  clientDB: clientDB,
                  clientLocation: clientLocation,
                  clientStorage: clientStorage,
                  clientAnalytics: clientAnalytics,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
