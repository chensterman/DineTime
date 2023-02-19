part of 'input_bloc.dart';

class InputState extends Equatable {
  final String email;
  final String password;
  const InputState({
    this.email = "",
    this.password = "",
  });

  @override
  List<Object> get props => [email, password];

  InputState copyWith({
    String? email,
    String? password,
  }) {
    return InputState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
