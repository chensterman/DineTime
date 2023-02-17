part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class FormSubmission extends FormEvent {
  final String email;
  final String password;
  final String confirmPassword;
  const FormSubmission({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [email, password];
}
