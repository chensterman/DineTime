import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/locationpreferences.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/welcome_page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

// Page confirming email has been verified
class EmailVerified extends StatelessWidget {
  final LocationService clientLocation;
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const EmailVerified(
      {super.key,
      required this.clientLocation,
      required this.clientAuth,
      required this.clientDB,
      required this.clientStorage,
      required this.clientAnalytics});

  @override
  Widget build(BuildContext context) {
    final locationPermission = Provider.of<PermissionStatus>(context);
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
                const ProgressBar(percentCompletion: 0.4),
                const SizedBox(height: 100.0),
                Text(
                  "Email Verified.",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 30.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Your email has been ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        'successfully ',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontSize: 16.0),
                      ),
                      Text(
                        'verified!',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ]),
                const SizedBox(height: 45.0),
                // Go to next page on press
                ButtonFilled(
                  isDisabled: false,
                  text: "Continue",
                  onPressed: () {
                    if (locationPermission == PermissionStatus.denied) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationPreferences(
                            clientLocation: clientLocation,
                            clientAuth: clientAuth,
                            clientDB: clientDB,
                            clientStorage: clientStorage,
                            clientAnalytics: clientAnalytics,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Welcome(
                            clientAuth: clientAuth,
                            clientDB: clientDB,
                            clientLocation: clientLocation,
                            clientStorage: clientStorage,
                            clientAnalytics: clientAnalytics,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
