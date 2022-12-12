import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/views/fyf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Page to conclude onboarding process
class Welcome extends StatefulWidget {
  final Map<String, dynamic> userData;
  const Welcome({Key? key, required this.userData}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // Loading state
  bool isLoading = false;

  // Error state
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage('lib/assets/dinetime-white.png'),
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    "Welcome to DineTime.",
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    "Ready to discover new",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    "and exciting places to eat?",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 60.0),
                  ButtonOutlined(
                    text: "Let's Go!",
                    onPressed: () async {
                      // Display loading indicator
                      setState(() => isLoading = true);
                      // Attempt to update user data and go to FYF page
                      try {
                        User? currentUser = AuthService().getCurrentUser();
                        currentUser != null
                            ? DatabaseService(uid: currentUser.uid)
                                .updateUser(widget.userData)
                            : throw Exception;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindYourFood(),
                          ),
                        );
                      } catch (e) {
                        setState(() => errorMessage =
                            'An error occurred. Please try again later.');
                      }
                      // Remove loading indicator
                      setState(() => isLoading = false);
                    },
                  ),
                  // If error message is present
                  errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(errorMessage!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(color: Colors.white)),
                          ),
                        )
                      : Container(),
                  // Display on loading
                  isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
