import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/signin_page/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/input/input_bloc.dart';
import 'widgets/signup_button.dart';
import 'widgets/signup_loading.dart';
import 'widgets/signup_error.dart';

// Sign in page for the app
class SignUpLayout extends StatelessWidget {
  final Function callBack;
  SignUpLayout({Key? key, required this.callBack}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

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
                  left: 47.0, right: 30.0, top: size.height * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 9.0),
                  Text(
                    "Welcome to DineTime",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 27.0),
                  // Email text input widget
                  InputText(
                    hintText: "Enter your email address",
                    // Triggers error on button press below
                    onChanged: (value) {
                      context.read<InputBloc>().add(TypeEmail(text: value));
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // Password input text widget
                  InputPassword(
                    hintText: "Choose your password",
                    onChanged: (value) {
                      context.read<InputBloc>().add(TypePassword(text: value));
                    },
                  ),
                  const SizedBox(height: 10.0),
                  // Password input text widget
                  InputPassword(
                    hintText: "Confirm your password",
                    onChanged: (value) {
                      context
                          .read<InputBloc>()
                          .add(TypeConfirmPassword(text: value));
                    },
                  ),
                  const SizedBox(height: 30.0),
                  // Sign in button widget
                  const SignUpButton(),
                  const SizedBox(height: 16.0),
                  // If error message is present
                  const SignUpError(),
                  // Sign up page dialog
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already registered? ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      GestureDetector(
                          onTap: () {
                            callBack();
                          },
                          child: Text(
                            'Sign In',
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
                  const SignUpLoading(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
