import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/views/home/home.dart';
import 'package:dinetime_mobile_mvp/views/onboarding/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Sign in page for the app
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Form validation
  final _formKey = GlobalKey<FormState>();

  // Text input states
  String email = '';
  String password = '';

  // Loading state
  bool isLoading = false;

  // Error state
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    // Get screen size
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: 30.0, right: 30.0, top: size.height * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign In",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Welcome to DineTime",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 30.0),
                  // Email text input widget
                  InputText(
                    hintText: "Enter your email address",
                    // Triggers error on button press below
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // Password input text widget
                  InputPassword(
                    hintText: "Enter your password",
                    // Triggers error on button press below
                    validator: (value) {
                      if (value!.length < 8) {
                        return "Password must be at least eight characters";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 30.0),
                  // Sign in button widget
                  ButtonFilled(
                    text: "Sign In",
                    // Firebase auth login and route to next page
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Display loading indicator
                        setState(() => isLoading = true);
                        // Attempt to sign into Firebase
                        try {
                          // Sign in using Firebase
                          await AuthService().signIn(email, password);
                          // At this point AuthStateCheck in main will route
                          // to next page
                        } on FirebaseAuthException catch (e) {
                          setState(() => errorMessage = e.message);
                        } catch (e) {
                          setState(() => errorMessage =
                              'An error occurred. Please try again later.');
                        }
                        // Remove loading indicator
                        setState(() => isLoading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
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
                                    ?.copyWith(color: Colors.red)),
                          ),
                        )
                      : Container(),
                  // Sign up page dialog
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Need an account? ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontSize: 16.0,
                                    decoration: TextDecoration.underline),
                          )),
                    ],
                  ),
                  // Display on loading
                  isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: CircularProgressIndicator(),
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
