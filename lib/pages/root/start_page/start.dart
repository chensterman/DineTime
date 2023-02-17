import 'dart:async';

import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/root/routing_page/routing.dart';
import 'package:flutter/material.dart';

// Start page with a 5 second viewing of the DineTime logo
class Start extends StatelessWidget {
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final LocationService clientLocation;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const Start({
    super.key,
    required this.clientAuth,
    required this.clientDB,
    required this.clientLocation,
    required this.clientStorage,
    required this.clientAnalytics,
  });

  @override
  Widget build(context) {
    // Timer to display DineTime logo before routing to AuthStateCheck
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Routing(
                  clientAuth: clientAuth,
                  clientDB: clientDB,
                  clientLocation: clientLocation,
                  clientStorage: clientStorage,
                  clientAnalytics: clientAnalytics,
                )));
      },
    );
    // DineTime logo displayed
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Padding(
        padding: EdgeInsets.all(64.0),
        child: Center(
          child: Image(
            image: AssetImage('lib/assets/dinetime-combo-white.png'),
          ),
        ),
      ),
    );
  }
}
