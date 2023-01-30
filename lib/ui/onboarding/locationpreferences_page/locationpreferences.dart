import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/locationallowed/locationallowed_bloc.dart';
import 'locationpreferences_layout.dart';

class LocationPreferences extends StatelessWidget {
  const LocationPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocationAllowedBloc()),
      ],
      child: const LocationPreferencesLayout(),
    );
  }
}
