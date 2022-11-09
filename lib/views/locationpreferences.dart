import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

// Page to enable location settings
// TODO:
//  Error handling widget (for permission denied)
class LocationPreferences extends StatefulWidget {
  final Map<String, dynamic> userData;
  const LocationPreferences({
    Key? key,
    required this.userData,
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
                  "You can change your location",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  "settings at any time",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Allow DineTime to use your location to ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "help you find local restaurants around ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "your area",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 60.0),
                ButtonFilled(
                  text: "Allow Location",
                  onPressed: () async {
                    // Enable location service
                    Location location = Location();
                    bool serviceEnabled = await location.serviceEnabled();
                    if (!serviceEnabled) {
                      serviceEnabled = await location.requestService();
                    }
                    // Get user permission for location tracking
                    PermissionStatus permissionGranted =
                        await location.hasPermission();
                    if (permissionGranted == PermissionStatus.denied) {
                      permissionGranted = await location.requestPermission();
                    }
                    // Go to next page if permission granted and pass user data map in
                    if (permissionGranted == PermissionStatus.granted &&
                        mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Welcome(userData: widget.userData)),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30.0),
                // Widget to push to next page on permission denied
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Welcome(userData: widget.userData)),
                            );
                          },
                          child: Text(
                            'Not Now',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          )),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
