import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'preorderbag_event.dart';
part 'preorderbag_state.dart';

class PreorderBagBloc extends Bloc<PreorderBagEvent, PreorderBagState> {
  final PreorderBag preorderBag;
  PreorderBagBloc({
    required this.preorderBag,
  }) : super(PreorderBagData(preorderBag: preorderBag)) {
    on<PreorderBagUpdate>(_onPreorderBagUpdate);
  }

  void _onPreorderBagUpdate(
      PreorderBagUpdate event, Emitter<PreorderBagState> emit) async {
    emit(PreorderBagLoading());
    preorderBag.updateBag(event.preorderItem);
    emit(PreorderBagData(preorderBag: preorderBag));
  }
}
