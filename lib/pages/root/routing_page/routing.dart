import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/root/home_page/home.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/locationpreferences.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/verifyemail_page/verifyemail.dart';
import 'package:dinetime_mobile_mvp/pages/root/routing_page/wrappers/auth_wrapper.dart';
import 'package:dinetime_mobile_mvp/pages/web/businessbyid.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class Routing extends StatelessWidget {
  // For web purposes
  final String? businessId;
  const Routing({
    this.businessId,
    super.key,
  });

  @override
  Widget build(context) {
    final user = Provider.of<UserDT?>(context);
    final services = Provider.of<Services>(context);
    if (user == null) {
      return const AuthWrapper();
    } else {
      // Web logic here
      final url = Uri.base.toString();
      final index = url.indexOf("=");
      final businessId = url.substring(index + 1);
      print(businessId);
      if (kIsWeb && index != -1) {
        return BusinessById(
            restaurantId: businessId, services: services, user: user);
      }
      return Home(
        user: user,
        services: services,
      );
    }
  }
}
