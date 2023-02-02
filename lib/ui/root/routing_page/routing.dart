import 'package:dinetime_mobile_mvp/ui/home/home_page/home.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/locationpreferences_page/locationpreferences.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/signup_page/signup.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/verifyemail_page/verifyemail.dart';
import 'package:dinetime_mobile_mvp/ui/root/auth_wrapper/authwrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Routing extends StatelessWidget {
  const Routing({super.key});

  @override
  Widget build(context) {
    final user = Provider.of<User?>(context);
    final locationPermission = Provider.of<PermissionStatus>(context);
    if (user == null) {
      return const AuthWrapper();
    } else {
      if (user.emailVerified) {
        if (locationPermission == PermissionStatus.denied) {
          return const LocationPreferences();
        } else {
          return const Home();
        }
      } else {
        return VerifyEmail(email: user.email!);
      }
    }
  }
}
