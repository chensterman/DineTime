import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/widgets/locationpreferences_button.dart';
import 'package:flutter/material.dart';

// Page to enable location settings
class LocationPreferencesLayout extends StatelessWidget {
  const LocationPreferencesLayout({
    Key? key,
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
                  style: dineTimeTypography.headlineLarge,
                ),
                Text(
                  "preferences",
                  style: dineTimeTypography.headlineLarge,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Location services must be enabled",
                  style: dineTimeTypography.bodyMedium?.copyWith(
                    color: dineTimeColorScheme.primary,
                  ),
                ),
                Text(
                  "in order to use DineTime",
                  style: dineTimeTypography.bodyMedium?.copyWith(
                    color: dineTimeColorScheme.primary,
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  "DineTime uses your location to ",
                  style: dineTimeTypography.bodySmall?.copyWith(
                    color: dineTimeColorScheme.onSurface,
                  ),
                ),
                Text(
                  "help you find local restaurants and pop-ups ",
                  style: dineTimeTypography.bodySmall?.copyWith(
                    color: dineTimeColorScheme.onSurface,
                  ),
                ),
                Text(
                  "around your area",
                  style: dineTimeTypography.bodySmall?.copyWith(
                    color: dineTimeColorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 60.0),
                const LocationPreferencesButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
