import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './signin_layout.dart';

import 'blocs/input/input_bloc.dart';
import 'blocs/form/form_bloc.dart' as fb;

class SignIn extends StatelessWidget {
  final Function callBack;
  final AuthService clientAuth;
  const SignIn({
    super.key,
    required this.callBack,
    required this.clientAuth,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InputBloc()),
        BlocProvider(create: (context) => fb.FormBloc(clientAuth)),
      ],
      child: SignInLayout(
        callBack: callBack,
      ),
    );
  }
}
