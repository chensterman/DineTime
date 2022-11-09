import 'dart:async';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/views/emailverified.dart';

// Email verification page
// TODO:
//  Resend email is rate limited
class VerifyEmail extends StatefulWidget {
  final String email;
  const VerifyEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  User? user = AuthService().getCurrentUser();
  late Timer timer;

  @override
  void initState() {
    // Sends verification email if user not null
    user != null ? user!.sendEmailVerification() : {};

    // Check every 5 seconds for verification
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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
                const ProgressBar(percentCompletion: 0.2),
                const SizedBox(height: 100.0),
                Text(
                  "Verify your email.",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Please click the verification link",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Row(children: [
                  Text(
                    "we sent to ",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    widget.email,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontSize: 16.0),
                  ),
                ]),
                const SizedBox(height: 30.0),
                // TODO: Firebase limits how many times a new account can have this email sent.
                ButtonOutlined(
                  text: 'Resend Email',
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check that a user has responded to the verification email
  Future<void> checkEmailVerified() async {
    // Reloads current user info from Firebase
    user != null ? user!.reload() : {};

    // Send to registration if verified
    if (user != null && user!.emailVerified) {
      timer.cancel();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const EmailVerified()));
    }
  }
}
