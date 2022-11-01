import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/material.dart';

class EmailVerified extends StatefulWidget {
  const EmailVerified({Key? key}) : super(key: key);

  @override
  State<EmailVerified> createState() => _EmailVerifiedState();
}

class _EmailVerifiedState extends State<EmailVerified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email Verified.",
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
            ButtonFilled(
              text: "Continue",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
