import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/form/form_bloc.dart' as fb;

class SignUpLoading extends StatelessWidget {
  const SignUpLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<fb.FormBloc, fb.FormState>(builder: (context, state) {
      if (state is fb.FormLoading) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: CircularProgressIndicator(
              color: dineTimeColorScheme.primary,
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
