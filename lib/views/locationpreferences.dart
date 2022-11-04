import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/views/welcome.dart';
import 'package:flutter/material.dart';

class LocationPreferences extends StatefulWidget {
  const LocationPreferences({Key? key}) : super(key: key);

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Welcome()),
                    );
                  },
                ),
                const SizedBox(height: 30.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {},
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
