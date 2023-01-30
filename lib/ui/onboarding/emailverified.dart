import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/locationpreferences.dart';
import 'package:flutter/material.dart';

// Page confirming email has been verified
class EmailVerified extends StatelessWidget {
  const EmailVerified({super.key});

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
                const ProgressBar(percentCompletion: 0.4),
                const SizedBox(height: 100.0),
                Text(
                  "Email Verified.",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 30.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Your email has been ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        'successfully ',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontSize: 16.0),
                      ),
                      Text(
                        'verified!',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ]),
                const SizedBox(height: 45.0),
                // Go to next page on press
                ButtonFilled(
                  isDisabled: false,
                  text: "Continue",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationPreferences(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
