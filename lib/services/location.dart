import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  final int _permissionInterval = 3;

  Stream<PermissionStatus> getLocationPermissionStatus() async* {
    yield* Stream.periodic(Duration(seconds: _permissionInterval), (_) {
      return _location.hasPermission();
    }).asyncMap((event) async => await event);
  }

  Future<void> requestUserPermission() async {
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
  }

  Future<GeoPoint?> getLocationData() async {
    LocationData locationData = await _location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return null;
    } else {
      return GeoPoint(locationData.latitude!, locationData.longitude!);
    }
  }
}
