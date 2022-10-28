import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Form validation
  final _formKey = GlobalKey<FormState>();

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
                  const InputText(hintText: "Enter your email address"),
                  const SizedBox(height: 10.0),
                  const InputPassword(hintText: "Create password"),
                  const SizedBox(height: 10.0),
                  const InputPassword(hintText: "Confirm password"),
                  const SizedBox(height: 30.0),
                  const ButtonFilled(text: "Sign Up"),
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
