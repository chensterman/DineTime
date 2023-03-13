import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'preorderbag_event.dart';
part 'preorderbag_state.dart';

class PreorderBagBloc extends Bloc<PreorderBagEvent, PreorderBagState> {
  final PreorderBag preorderBag;
  final DatabaseService clientDB;
  PreorderBagBloc({
    required this.preorderBag,
    required this.clientDB,
  }) : super(PreorderBagData(preorderBag: preorderBag)) {
    on<PreorderBagUpdate>(_onPreorderBagUpdate);
    on<PreorderBagSubmit>(_onPreorderBagSubmit);
  }

  void _onPreorderBagUpdate(
      PreorderBagUpdate event, Emitter<PreorderBagState> emit) async {
    emit(PreorderBagLoading());
    preorderBag.updateBag(event.preorderItem);
    emit(PreorderBagData(preorderBag: preorderBag));
  }

  void _onPreorderBagSubmit(
      PreorderBagSubmit event, Emitter<PreorderBagState> emit) async {
    emit(PreorderBagLoading());
    await clientDB.preorderCreate(event.customerId, preorderBag);
  }
}
