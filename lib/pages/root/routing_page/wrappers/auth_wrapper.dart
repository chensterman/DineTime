import 'package:dinetime_mobile_mvp/pages/onboarding/signin_page/signin.dart';
import 'package:dinetime_mobile_mvp/pages/onboarding/signup_page/signup.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isSignUp = true;

  // callback function
  callBack() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignUp
        ? SignUp(
            callBack: callBack,
          )
        : SignIn(
            callBack: callBack,
          );
  }
}
