import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/blocs/locationallowed/locationallowed_bloc.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/locationpreferences_page/widgets/locationpreferences_error_dialog.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/welcome_page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Page to enable location settings
class LocationPreferencesButton extends StatelessWidget {
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final LocationService clientLocation;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const LocationPreferencesButton({
    Key? key,
    required this.clientAuth,
    required this.clientDB,
    required this.clientLocation,
    required this.clientStorage,
    required this.clientAnalytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationAllowedBloc, LocationAllowedState>(
      listener: (context, state) {
        if (state is PermissionGiven) {
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
        } else {
          showDialog(
              context: context,
              builder: (context) => const LocationPreferencesErrorDialog());
        }
      },
      child: ButtonFilled(
        isDisabled: false,
        text: "Allow Location",
        onPressed: () {
          context.read<LocationAllowedBloc>().add(CheckPermission());
        },
      ),
    );
  }
}
