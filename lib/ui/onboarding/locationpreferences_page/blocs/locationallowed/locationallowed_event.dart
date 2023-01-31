part of 'locationallowed_bloc.dart';

abstract class LocationAllowedEvent extends Equatable {
  const LocationAllowedEvent();

  @override
  List<Object> get props => [];
}

class CheckPermission extends LocationAllowedEvent {}
