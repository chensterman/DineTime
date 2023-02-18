import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Services {
  final AuthService clientAuth;
  final LocationService clientLocation;
  final DatabaseService clientDB;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const Services({
    required this.clientAuth,
    required this.clientLocation,
    required this.clientDB,
    required this.clientStorage,
    required this.clientAnalytics,
  });
}

abstract class AuthService {
  UserDT? getCurrentUser();
  String? getCurrentUserUid();
  Stream<UserDT?> streamUserState();
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> sendEmailVerification();
}

abstract class LocationService {
  Stream<PermissionStatus> getLocationPermissionStatus();
  Future<PermissionStatus> requestUserPermission();
  Future<GeoPoint?> getLocationData();
  double distanceBetweenTwoPoints(GeoPoint p1, GeoPoint p2);
  Future<GeoPoint?> addressToGeoPoint(String address);
  Future<String?> geoPointToAddress(GeoPoint geoPoint);
}

abstract class DatabaseService {
  Future<void> customerCreate(String customerId);
  Future<void> customerUpdate(
      String customerId, Map<String, dynamic> customerData);
  Future<Customer?> customerGet(String customerId);
  Future<void> customerAddFavorite(String customerId, String restaurantId);
  Future<void> customerDeleteFavorite(String customerId, String restaurantId);
  Stream<List<Restaurant>> customerFavoritesStream(String customerId);
  Future<List<Restaurant>> customerSwipe(String customerId);
  Future<Restaurant?> restaurantGet(String restaurantId);
}

abstract class StorageService {
  Future<ImageProvider<Object>> getPhoto(String photoPath);
}

abstract class AnalyticsService {
  void trackEvent(String eventName);
  void trackScreenView(String pageName);
}
