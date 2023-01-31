import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc() : super(FormIdle()) {
    on<FormSubmission>(_onFormSubmission);
  }

  void _onFormSubmission(FormSubmission event, Emitter<FormState> emit) async {
    String email = event.email;
    String password = event.password;
    String confirmPassword = event.confirmPassword;
    emit(FormLoading());
    if (password.length < 8) {
      emit(const FormError(
          errorMessage: "Password must be at least 8 characters."));
    } else if (password != confirmPassword) {
      emit(const FormError(errorMessage: "Passwords must match."));
    } else {
      try {
        // Sign in using Firebase
        await AuthService().signUp(email, password);
        emit(FormIdle());
      } on FirebaseAuthException catch (e) {
        emit(FormError(errorMessage: e.message ?? ""));
      } catch (e) {
        emit(const FormError(
            errorMessage: "An error occurred. Please try again later."));
      }
    }
  }
}
