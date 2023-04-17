part of 'editfoodcard_bloc.dart';

abstract class EditFoodCardEvent extends Equatable {
  const EditFoodCardEvent();

  @override
  List<Object> get props => [];
}

class EditFoodCardUpdateName extends EditFoodCardEvent {
  final String newName;
  const EditFoodCardUpdateName({
    required this.newName,
  });

  @override
  List<Object> get props => [newName];
}

class EditFoodCardUpdateBio extends EditFoodCardEvent {
  final String newBio;
  const EditFoodCardUpdateBio({
    required this.newBio,
  });

  @override
  List<Object> get props => [newBio];
}

class EditFoodCardSubmit extends EditFoodCardEvent {
  final String restaurantId;
  const EditFoodCardSubmit({
    required this.restaurantId,
  });

  @override
  List<Object> get props => [restaurantId];
}
