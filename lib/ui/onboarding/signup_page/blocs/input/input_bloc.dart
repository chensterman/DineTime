import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'input_event.dart';
part 'input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  InputBloc() : super(const InputState()) {
    on<TypeEmail>(_onTypeEmail);
    on<TypePassword>(_onTypePassword);
    on<TypeConfirmPassword>(_onTypeConfirmPassword);
  }

  void _onTypeEmail(TypeEmail event, Emitter<InputState> emit) {
    emit(state.copyWith(email: event.text));
  }

  void _onTypePassword(TypePassword event, Emitter<InputState> emit) {
    emit(state.copyWith(password: event.text));
  }

  void _onTypeConfirmPassword(
      TypeConfirmPassword event, Emitter<InputState> emit) {
    emit(state.copyWith(confirmPassword: event.text));
  }
}
