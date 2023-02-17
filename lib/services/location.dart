import 'dart:math';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

abstract class LocationService {
  Stream<PermissionStatus> getLocationPermissionStatus();
  requestUserPermission();
  getLocationData();
  distanceBetweenTwoPoints(GeoPoint p1, GeoPoint p2);
  Future<GeoPoint?> addressToGeoPoint(String address);
  Future<String?> geoPointToAddress(GeoPoint geoPoint);
}

// Contains all methods and data pertaining to user device location
class LocationServiceApp implements LocationService {
  final Location _location = Location();
  final int _permissionInterval = 3;

  // Stream keeping updates on the permissioning the user has given for location
  @override
  Stream<PermissionStatus> getLocationPermissionStatus() async* {
    yield* Stream.periodic(Duration(seconds: _permissionInterval), (_) {
      return _location.hasPermission();
    }).asyncMap((event) async => await event);
  }

  // Enable location services on the user device and ask the user
  // for permission to access their location (native iOS or Android dialog)
  @override
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
  @override
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

  double _geopointToRadians(double geopoint) {
    double conversionFactor = pi / 180;
    return conversionFactor * geopoint;
  }

  @override
  double distanceBetweenTwoPoints(GeoPoint p1, GeoPoint p2) {
    double radLat1 = _geopointToRadians(p1.latitude);
    double radLong1 = _geopointToRadians(p1.longitude);
    double radLat2 = _geopointToRadians(p2.latitude);
    double radLong2 = _geopointToRadians(p2.longitude);

    // Haversine Formula
    double distLat = radLat2 - radLat1;
    double distLong = radLong2 - radLong1;
    double ans = pow(sin(distLat / 2), 2) +
        cos(radLat1) * cos(radLat2) * pow(sin(distLong / 2), 2);
    ans = 2 * asin(sqrt(ans));

    // Radius of earth in miles
    double radiusOfEarth = 3956;
    ans = ans * radiusOfEarth;
    num mod = pow(10.0, 1);
    ans = ((ans * mod).round().toDouble() / mod);
    return ans;
  }

  // Converts address to Geopoint
  @override
  Future<GeoPoint?> addressToGeoPoint(String address) async {
    List<geocoding.Location> location =
        await geocoding.locationFromAddress(address);
    var geoPoint = GeoPoint(location[0].latitude, location[0].longitude);
    return geoPoint;
  }

  @override
  Future<String?> geoPointToAddress(GeoPoint geoPoint) async {
    List<geocoding.Placemark> location = await geocoding
        .placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
    String locationStr = "";
    if (location[0].locality!.isNotEmpty) {
      locationStr = locationStr + location[0].locality.toString();
    }
    if (location[0].administrativeArea!.isNotEmpty &&
        location[0].postalCode!.isNotEmpty) {
      locationStr =
          "$locationStr, ${location[0].administrativeArea.toString()} ${location[0].postalCode}";
    }
    return locationStr;
  }
}
