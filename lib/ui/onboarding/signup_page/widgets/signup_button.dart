import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/ui/root/routing_page/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/input/input_bloc.dart';
import '../blocs/form/form_bloc.dart' as fb;

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputBloc, InputState>(builder: (context, state) {
      String email = state.email;
      String password = state.password;
      String confirmPassword = state.confirmPassword;
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        return const ButtonFilled(
          text: "Sign Up",
          isDisabled: true,
        );
      } else {
        return ButtonFilled(
          text: "Sign Up",
          isDisabled: false,
          onPressed: () {
            context.read<fb.FormBloc>().add(fb.FormSubmission(
                email: email,
                password: password,
                confirmPassword: confirmPassword));
          },
        );
      }
    });
  }
}
