import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:location/location.dart';

class LocationServiceMock extends LocationService {
  PermissionStatus _locationPermission = PermissionStatus.denied;
  final GeoPoint _locationData = const GeoPoint(47.60, 122.33);

  @override
  Stream<PermissionStatus> getLocationPermissionStatus() {
    return Stream.periodic(Duration.zero, (_) => _locationPermission);
  }

  @override
  Future<PermissionStatus> requestUserPermission() async {
    await Future.delayed(Duration.zero);
    _locationPermission = PermissionStatus.granted;
    return _locationPermission;
  }

  @override
  Future<GeoPoint?> getLocationData() async {
    await Future.delayed(Duration.zero);
    return _locationData;
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
