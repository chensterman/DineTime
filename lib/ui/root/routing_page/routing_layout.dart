import 'package:dinetime_mobile_mvp/ui/home/home.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/locationpreferences.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/signup_page/signup.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/verifyemail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RoutingLayout extends StatelessWidget {
  const RoutingLayout({super.key});

  @override
  Widget build(context) {
    final user = Provider.of<User?>(context);
    final locationPermission = Provider.of<PermissionStatus>(context);
    if (user == null) {
      return const SignUp();
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
