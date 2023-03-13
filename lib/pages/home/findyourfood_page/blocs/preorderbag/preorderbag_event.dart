part of 'preorderbag_bloc.dart';

abstract class PreorderBagEvent extends Equatable {
  const PreorderBagEvent();

  @override
  List<Object> get props => [];
}

class PreorderBagUpdate extends PreorderBagEvent {
  final PreorderItem preorderItem;
  const PreorderBagUpdate({
    required this.preorderItem,
  });

  @override
  List<Object> get props => [preorderItem];
}

class PreorderBagSubmit extends PreorderBagEvent {
  final String customerId;
  const PreorderBagSubmit({
    required this.customerId,
  });

  @override
  List<Object> get props => [customerId];
}
