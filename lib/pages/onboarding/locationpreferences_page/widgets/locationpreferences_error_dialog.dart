import 'package:flutter/material.dart';

class LocationPreferencesErrorDialog extends StatelessWidget {
  const LocationPreferencesErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
          "Please visit your settings and allow location services for DineTime."),
      actions: <Widget>[
        TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
