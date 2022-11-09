import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/views/onboarding/verifyemail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Sign up page
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Form validation
  final _formKey = GlobalKey<FormState>();

  // Text input states
  String email = '';
  String password = '';
  String confirmPassword = '';

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
                    "Sign Up",
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
                    hintText: "Create your password",
                    // Triggers error on button press below
                    validator: (value) {
                      if (value!.length < 8) {
                        return "Password must be at least eight characters";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // Confirm password input text widget
                  InputPassword(
                    hintText: "Confirm password",
                    // Triggers error on button press below
                    validator: (value) {
                      if (value != password) {
                        return "Passwords must match";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        // Trim password of spaces at the ends
                        confirmPassword = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ButtonFilled(
                    text: "Sign Up",
                    // Firebase auth login and route to next page
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Display loading indicator
                        setState(() => isLoading = true);
                        // Attempt to sign up using Firebase
                        try {
                          // Sign user up
                          await AuthService().signUp(email, password);
                          // Go to next page
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VerifyEmail(email: email)),
                            );
                          }
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
                  // Sign in page dialog
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Already registered? ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Sign in',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      fontSize: 16.0,
                                      decoration: TextDecoration.underline),
                            )),
                      ]),
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
