import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/root/home_page/home.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/locationpreferences.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/verifyemail_page/verifyemail.dart';
import 'package:dinetime_mobile_mvp/pages/root/routing_page/wrappers/auth_wrapper.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Routing extends StatelessWidget {
  const Routing({
    super.key,
  });

  @override
  Widget build(context) {
    final user = Provider.of<UserDT?>(context);
    final locationPermission = Provider.of<PermissionStatus>(context);
    final services = Provider.of<Services>(context);
    if (user == null) {
      return const AuthWrapper();
    } else {
      if (user.emailVerified) {
        if (locationPermission == PermissionStatus.denied) {
          return const LocationPreferences();
        } else {
          return Home(
            user: user,
            services: services,
          );
        }
      } else {
        return VerifyEmail(
          email: user.email,
          services: services,
        );
      }
    }
  }
}
