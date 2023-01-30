part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class FormSubmission extends FormEvent {
  final String email;
  final String password;
  const FormSubmission({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
