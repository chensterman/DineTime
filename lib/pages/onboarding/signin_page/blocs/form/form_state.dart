part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  const FormState();

  @override
  List<Object> get props => [];
}

class FormIdle extends FormState {}

class FormLoading extends FormState {}

class FormError extends FormState {
  final String errorMessage;
  const FormError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
