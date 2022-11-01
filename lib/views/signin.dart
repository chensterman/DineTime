import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/views/fyf.dart';
import 'package:dinetime_mobile_mvp/views/signup.dart';
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
                        password = value;
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
                        // Sign in using Firebase
                        // TODO: generate error dialog using status
                        int status =
                            await AuthService().signIn(email, password);
                        if (status == 0) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FindYourFood()),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
