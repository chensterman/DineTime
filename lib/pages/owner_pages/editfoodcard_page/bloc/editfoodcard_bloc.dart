import 'dart:io';

import 'package:dinetime_mobile_mvp/models/owner.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'editfoodcard_event.dart';
part 'editfoodcard_state.dart';

class EditFoodCardBloc extends Bloc<EditFoodCardEvent, EditFoodCardState> {
  final Restaurant editFields;
  final DatabaseService clientDB;
  Map<String, File>? galleryPhotos;
  Map<String, File>? menuPhotos;
  File? coverPhoto;

  EditFoodCardBloc({
    required this.editFields,
    required this.clientDB,
    this.galleryPhotos,
    this.menuPhotos,
    this.coverPhoto,
  }) : super(EditFoodCardData(
            editFields: editFields,
            clientDB: clientDB,
            galleryPhotos: galleryPhotos,
            menuPhotos: menuPhotos,
            coverPhoto: coverPhoto)) {
    on<EditFoodCardUpdateName>(_onEditFoodCardUpdateName);
    on<EditFoodCardUpdateBio>(_onEditFoodCardUpdateBio);
    on<EditFoodCardSubmit>(_onEditFoodCardSubmit);
  }

  void _onEditFoodCardUpdateName(
      EditFoodCardUpdateName event, Emitter<EditFoodCardState> emit) async {
    emit(EditFoodCardLoading());
    editFields.restaurantName = event.newName;
    emit(EditFoodCardData(
        editFields: editFields,
        clientDB: clientDB,
        galleryPhotos: galleryPhotos,
        menuPhotos: menuPhotos,
        coverPhoto: coverPhoto));
  }

  void _onEditFoodCardUpdateBio(
      EditFoodCardUpdateBio event, Emitter<EditFoodCardState> emit) async {
    emit(EditFoodCardLoading());
    editFields.bio = event.newBio;
    emit(EditFoodCardData(
        editFields: editFields,
        clientDB: clientDB,
        galleryPhotos: galleryPhotos,
        menuPhotos: menuPhotos,
        coverPhoto: coverPhoto));
  }

  void _onEditFoodCardSubmit(
      EditFoodCardSubmit event, Emitter<EditFoodCardState> emit) async {
    emit(EditFoodCardLoading());
    await clientDB.restaurantUpdate(
        editFields, event.restaurantId, galleryPhotos, menuPhotos, coverPhoto);
  }
}
