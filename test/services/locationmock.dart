import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';

class LocationServiceMock extends LocationService {
  @override
  Future<GeoPoint?> getLocationData() async {
    await Future.delayed(Duration.zero);
    return const GeoPoint(0, 0);
  }
}
