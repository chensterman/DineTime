import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/locationallowed/locationallowed_bloc.dart';
import 'locationpreferences_layout.dart';

class LocationPreferences extends StatelessWidget {
  final LocationService clientLocation;
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const LocationPreferences({
    super.key,
    required this.clientLocation,
    required this.clientAuth,
    required this.clientDB,
    required this.clientStorage,
    required this.clientAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LocationAllowedBloc(
                  clientLocation,
                  clientAuth,
                  clientDB,
                )),
      ],
      child: LocationPreferencesLayout(
        clientAuth: clientAuth,
        clientDB: clientDB,
        clientLocation: clientLocation,
        clientStorage: clientStorage,
        clientAnalytics: clientAnalytics,
      ),
    );
  }
}
