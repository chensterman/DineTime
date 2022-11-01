import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/views/fyf.dart';
import 'package:dinetime_mobile_mvp/views/verifyemail.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
                        confirmPassword = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ButtonFilled(
                    text: "Sign Up",
                    // Firebase auth login and route to next page
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Sign in using Firebase
                        // TODO: generate error dialog using status
                        int status =
                            await AuthService().signUp(email, password);
                        if (status == 0) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VerifyEmail(email: email)),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
