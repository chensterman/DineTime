part of 'editfoodcard_bloc.dart';

abstract class EditFoodCardState extends Equatable {
  const EditFoodCardState();

  @override
  List<dynamic> get props => [];
}

class EditFoodCardLoading extends EditFoodCardState {}

class EditFoodCardData extends EditFoodCardState {
  final Restaurant editFields;
  final DatabaseService clientDB;
  final Map<String, File>? galleryPhotos;
  final Map<String, File>? menuPhotos;
  final File? coverPhoto;
  const EditFoodCardData({
    required this.editFields,
    required this.clientDB,
    this.galleryPhotos,
    this.menuPhotos,
    this.coverPhoto,
  });

  @override
  List<dynamic> get props =>
      [editFields, clientDB, galleryPhotos, menuPhotos, coverPhoto];
}
