import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/home/home_page/home.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/locationpreferences.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/verifyemail_page/verifyemail.dart';
import 'package:dinetime_mobile_mvp/pages/root/routing_page/wrappers/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Routing extends StatelessWidget {
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final LocationService clientLocation;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const Routing({
    super.key,
    required this.clientAuth,
    required this.clientDB,
    required this.clientLocation,
    required this.clientStorage,
    required this.clientAnalytics,
  });

  @override
  Widget build(context) {
    final user = Provider.of<User?>(context);
    final locationPermission = Provider.of<PermissionStatus>(context);
    if (user == null) {
      return AuthWrapper(
        clientAuth: clientAuth,
      );
    } else {
      if (user.emailVerified) {
        if (locationPermission == PermissionStatus.denied) {
          return LocationPreferences(
            clientLocation: clientLocation,
            clientAuth: clientAuth,
            clientDB: clientDB,
            clientStorage: clientStorage,
            clientAnalytics: clientAnalytics,
          );
        } else {
          return Home(
            clientAuth: clientAuth,
            clientDB: clientDB,
            clientLocation: clientLocation,
            clientStorage: clientStorage,
            clientAnalytics: clientAnalytics,
          );
        }
      } else {
        return VerifyEmail(
          email: user.email!,
          clientLocation: clientLocation,
          clientAuth: clientAuth,
          clientDB: clientDB,
          clientStorage: clientStorage,
          clientAnalytics: clientAnalytics,
        );
      }
    }
  }
}
