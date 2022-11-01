import 'dart:async';
import 'package:dinetime_mobile_mvp/views/emailverified.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  const VerifyEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    // Firebase function: sends verification email
    user = auth.currentUser!;
    user.sendEmailVerification();

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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verify your email.",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Please click the verification link we sent to",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.email,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Didn\'t get an email? ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      GestureDetector(
                          onTap: () async {
                            await user.sendEmailVerification();
                          },
                          child: Text(
                            'Resend now',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontSize: 16.0,
                                    decoration: TextDecoration.underline),
                          )),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to check that a user has responded to the verification email
  Future<void> checkEmailVerified() async {
    // Reloads current user info from Firebase
    user = auth.currentUser!;
    await user.reload();

    // Send to registration if verified
    if (user.emailVerified) {
      timer.cancel();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const EmailVerified()));
    }
  }
}
