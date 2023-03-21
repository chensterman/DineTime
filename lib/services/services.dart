import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/owner.dart';
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
  Future<UserDT?> getCurrentUser();
  String? getCurrentUserUid();
  Stream<UserDT?> streamUserState();
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> sendEmailVerification();
  Future<void> deleteAccount();
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
  Future<void> customerDelete(String customerId);
  Future<Customer?> customerGet(String customerId);
  Future<void> customerAddFavorite(String customerId, String restaurantId);
  Future<void> customerDeleteFavorite(String customerId, String restaurantId);
  Stream<List<Restaurant>> customerFavoritesStream(String customerId);
  Stream<List<Restaurant>> customerAllStream();
  Stream<List<PreorderBag>> customerPreordersStream(String customerId);
  Future<List<Restaurant>> customerSwipe(String customerId);
  Future<Owner?> ownerGet(String ownerId);
  Future<Restaurant?> restaurantGet(String restaurantId);
  Future<MenuItem?> restaurantMenuItemGet(String restaurantId, String itemId);
  Future<PopUpLocation?> restaurantLocationGet(
      String restaurantId, String locationId);
  Stream<List<PreorderBag>> restaurantPreordersStream(
      String restaurantId, bool fulfilled);
  Future<void> preorderCreate(String customerId, PreorderBag preorderBag);
  Future<PreorderBag?> preorderGet(String preorderId);
}

abstract class StorageService {
  Future<ImageProvider<Object>> getPhoto(String photoPath);
}

abstract class AnalyticsService {
  void trackEvent(String eventName);
  void trackScreenView(String pageName, String screenClass);
  void trackEventNum(String eventName, double value);
}
