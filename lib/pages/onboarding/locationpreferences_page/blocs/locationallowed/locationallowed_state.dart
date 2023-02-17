part of 'locationallowed_bloc.dart';

abstract class LocationAllowedState extends Equatable {
  const LocationAllowedState();

  @override
  List<Object> get props => [];
}

class PermissionChecking extends LocationAllowedState {}

class PermissionNotGiven extends LocationAllowedState {}

class PermissionGiven extends LocationAllowedState {}
