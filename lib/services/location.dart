import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

// Contains all methods and data pertaining to user device location
class LocationService {
  final Location _location = Location();
  final int _permissionInterval = 3;

  // Stream keeping updates on the permissioning the user has given for location
  Stream<PermissionStatus> getLocationPermissionStatus() async* {
    yield* Stream.periodic(Duration(seconds: _permissionInterval), (_) {
      return _location.hasPermission();
    }).asyncMap((event) async => await event);
  }

  // Enable location services on the user device and ask the user
  // for permission to access their location (native iOS or Android dialog)
  Future<PermissionStatus> requestUserPermission() async {
    // Enable location services
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    // Get user permission for location tracking
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted;
  }

  // Obtain the location of the user (null if permission not granted)
  Future<GeoPoint?> getLocationData() async {
    try {
      LocationData locationData = await _location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        return null;
      } else {
        return GeoPoint(locationData.latitude!, locationData.longitude!);
      }
    } catch (e) {
      return null;
    }
  }
}
