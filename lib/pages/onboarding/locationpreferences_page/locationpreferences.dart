import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'blocs/locationallowed/locationallowed_bloc.dart';
import 'locationpreferences_layout.dart';

class LocationPreferences extends StatelessWidget {
  const LocationPreferences({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocationAllowedBloc(
            services.clientLocation,
            services.clientAuth,
            services.clientDB,
          ),
        ),
      ],
      child: const LocationPreferencesLayout(),
    );
  }
}
