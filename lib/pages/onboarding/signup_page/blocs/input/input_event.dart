part of 'input_bloc.dart';

abstract class InputEvent extends Equatable {
  const InputEvent();

  @override
  List<Object> get props => [];
}

class TypeEmail extends InputEvent {
  final String text;
  const TypeEmail({required this.text});

  @override
  List<Object> get props => [text];
}

class TypePassword extends InputEvent {
  final String text;
  const TypePassword({required this.text});

  @override
  List<Object> get props => [text];
}

class TypeConfirmPassword extends InputEvent {
  final String text;
  const TypeConfirmPassword({required this.text});

  @override
  List<Object> get props => [text];
}
