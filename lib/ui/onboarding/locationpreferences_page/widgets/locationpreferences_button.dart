import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/locationpreferences_page/blocs/locationallowed/locationallowed_bloc.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/locationpreferences_page/widgets/locationpreferences_error_dialog.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/welcome_page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Page to enable location settings
class LocationPreferencesButton extends StatelessWidget {
  const LocationPreferencesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationAllowedBloc, LocationAllowedState>(
      listener: (context, state) {
        if (state is PermissionGiven) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Welcome()));
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
