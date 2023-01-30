import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'signup_layout.dart';

import 'blocs/input/input_bloc.dart';
import 'blocs/form/form_bloc.dart' as fb;

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InputBloc()),
        BlocProvider(create: (context) => fb.FormBloc()),
      ],
      child: SignUpLayout(),
    );
  }
}
