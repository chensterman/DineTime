import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/form/form_bloc.dart' as fb;

class SignInError extends StatelessWidget {
  const SignInError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<fb.FormBloc, fb.FormState>(builder: (context, state) {
      if (state is fb.FormError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(state.errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.red)),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
