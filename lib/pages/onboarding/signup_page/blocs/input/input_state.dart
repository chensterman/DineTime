part of 'input_bloc.dart';

class InputState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  const InputState({
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
  });

  @override
  List<Object> get props => [email, password, confirmPassword];

  InputState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return InputState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
