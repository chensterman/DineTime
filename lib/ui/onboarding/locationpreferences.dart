import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

// Page to enable location settings
class LocationPreferences extends StatefulWidget {
  const LocationPreferences({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationPreferences> createState() => _LocationPreferencesState();
}

class _LocationPreferencesState extends State<LocationPreferences> {
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
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  "preferences",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Location services must be enabled",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  "in order to use DineTime",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "DineTime uses your location to ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "help you find local restaurants and pop-ups ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "around your area",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 60.0),
                ButtonFilled(
                  isDisabled: false,
                  text: "Allow Location",
                  onPressed: () async {
                    // Instantiate location service class
                    LocationService location = LocationService();
                    // Enable location service and get user permission for
                    // location tracking
                    PermissionStatus locationPermission =
                        await location.requestUserPermission();
                    if (locationPermission == PermissionStatus.granted ||
                        locationPermission == PermissionStatus.grantedLimited) {
                      // On permission granted, get location data and
                      // update database
                      GeoPoint? userLocation = await location.getLocationData();
                      User user = AuthService().getCurrentUser()!;
                      await DatabaseService().updateCustomer(user.uid, {
                        'geolocation': userLocation,
                      });
                      // Go to next page
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Welcome(),
                          ),
                        );
                      }
                    } else {
                      // If permission denied, show dialog
                      showDialog(
                          context: context,
                          builder: (context) => errorDialog());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget errorDialog() {
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
