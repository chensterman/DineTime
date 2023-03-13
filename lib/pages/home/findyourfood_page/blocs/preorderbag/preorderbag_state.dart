part of 'preorderbag_bloc.dart';

abstract class PreorderBagState extends Equatable {
  const PreorderBagState();

  @override
  List<Object> get props => [];
}

class PreorderBagLoading extends PreorderBagState {}

class PreorderBagData extends PreorderBagState {
  final PreorderBag preorderBag;
  const PreorderBagData({
    required this.preorderBag,
  });

  @override
  List<Object> get props => [preorderBag];
}
