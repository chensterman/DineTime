import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'locationallowed_event.dart';
part 'locationallowed_state.dart';

class LocationAllowedBloc
    extends Bloc<LocationAllowedEvent, LocationAllowedState> {
  LocationAllowedBloc() : super(PermissionNotGiven()) {
    on<CheckPermission>(_onCheckPermission);
  }

  void _onCheckPermission(
      CheckPermission event, Emitter<LocationAllowedState> emit) async {
    // Instantiate location service class
    LocationService location = LocationService();
    // Enable location service and get user permission for
    // location tracking
    PermissionStatus locationPermission =
        await location.requestUserPermission();
    if (locationPermission == PermissionStatus.granted ||
        locationPermission == PermissionStatus.grantedLimited) {
      // On permission granted, get location data and
      // update database
      GeoPoint? userLocation = await location.getLocationData();
      User user = AuthService().getCurrentUser()!;
      await DatabaseService().updateCustomer(user.uid, {
        'geolocation': userLocation,
      });
      emit(PermissionGiven());
    } else {
      emit(PermissionGiven());
    }
  }
}
