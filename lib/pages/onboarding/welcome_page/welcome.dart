import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/home/home_page/home.dart';
import 'package:flutter/material.dart';

// Page to conclude onboarding process
class Welcome extends StatelessWidget {
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final LocationService clientLocation;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const Welcome({
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    width: 50.0,
                    height: 50.0,
                    image: AssetImage('lib/assets/dinetime-white.png'),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Welcome to DineTime.",
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    "Discover food you can't",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    "find anywhere else.",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 60.0),
                  ButtonOutlined(
                    text: "It's DineTime!",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            clientAuth: clientAuth,
                            clientDB: clientDB,
                            clientLocation: clientLocation,
                            clientStorage: clientStorage,
                            clientAnalytics: clientAnalytics,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
