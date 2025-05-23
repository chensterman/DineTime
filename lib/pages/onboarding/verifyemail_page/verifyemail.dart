import 'dart:async';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/emailverified_page/emailverified.dart';

// Email verification page
// TODO:
//  Resend email is rate limited
class VerifyEmail extends StatefulWidget {
  final String email;
  final Services services;
  const VerifyEmail({
    Key? key,
    required this.email,
    required this.services,
  }) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late Future<UserDT?> userFuture;
  late Timer timer;

  @override
  void initState() {
    // Safe to assume user is not null because in order to get to this page,
    //  User had to have been created.
    userFuture = widget.services.clientAuth.getCurrentUser();
    // Sends verification email
    widget.services.clientAuth.sendEmailVerification();

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
                  style: dineTimeTypography.headlineLarge,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Please click the verification link",
                  style: dineTimeTypography.bodySmall?.copyWith(
                    color: dineTimeColorScheme.onSurface,
                  ),
                ),
                Row(children: [
                  Text(
                    "we sent to ",
                    style: dineTimeTypography.bodySmall?.copyWith(
                      color: dineTimeColorScheme.onSurface,
                    ),
                  ),
                  Text(
                    widget.email,
                    style: dineTimeTypography.bodySmall?.copyWith(
                      color: dineTimeColorScheme.primary,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check that a user has responded to the verification email
  Future<void> checkEmailVerified() async {
    // Reloads current user info from Firebase Authentication
    UserDT? user = await widget.services.clientAuth.getCurrentUser();

    // Send to onboarding if verified
    if (user!.emailVerified && mounted) {
      timer.cancel();
      widget.services.clientAnalytics.trackEvent('completed_sign_up');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const EmailVerified(),
      ));
    }
  }
}
