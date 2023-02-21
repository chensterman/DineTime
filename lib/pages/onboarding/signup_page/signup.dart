import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'signup_layout.dart';

import 'blocs/input/input_bloc.dart';
import 'blocs/form/form_bloc.dart' as fb;

class SignUp extends StatelessWidget {
  final Function callBack;
  const SignUp({
    super.key,
    required this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InputBloc()),
        BlocProvider(create: (context) => fb.FormBloc(services.clientAuth)),
      ],
      child: SignUpLayout(
        callBack: callBack,
      ),
    );
  }
}
