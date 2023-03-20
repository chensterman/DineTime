import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';

import '../data/preordersdatamock.dart';
import '../data/restaurantdatamock.dart';

class DatabaseServiceMock extends DatabaseService {
  final List<Restaurant> _favoritedRestaurants =
      RestaurantDataMock().favoritedRestaurants;
  final List<Restaurant> _swipeRestaurants =
      RestaurantDataMock().swipeRestaurants;
  final List<PreorderBag> _preorders = PreordersDataMock().preorders;

  @override
  Future<void> customerCreate(String customerId) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> customerUpdate(
      String customerId, Map<String, dynamic> customerData) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<void> customerDelete(String customerId) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<Customer?> customerGet(String customerId) async {
    await Future.delayed(Duration.zero);
    return Customer(
      customerId: "123",
      geolocation: const GeoPoint(47.60, -122.33),
    );
  }

  @override
  Future<void> customerAddFavorite(
      String customerId, String restaurantId) async {
    await Future.delayed(Duration.zero);
    _favoritedRestaurants.add(_swipeRestaurants
        .where((restaurant) => restaurant.restaurantId == restaurantId)
        .first);
    _swipeRestaurants.remove(_swipeRestaurants
        .where((restaurant) => restaurant.restaurantId == restaurantId)
        .first);
  }

  @override
  Future<void> customerDeleteFavorite(
      String customerId, String restaurantId) async {
    await Future.delayed(Duration.zero);
    _swipeRestaurants.add(_favoritedRestaurants
        .where((restaurant) => restaurant.restaurantId == restaurantId)
        .first);
    _favoritedRestaurants.remove(_favoritedRestaurants
        .where((restaurant) => restaurant.restaurantId == restaurantId)
        .first);
  }

  @override
  Stream<List<Restaurant>> customerFavoritesStream(String customerId) async* {
    yield _favoritedRestaurants;
  }

  @override
  Stream<List<Restaurant>> customerAllStream() async* {
    yield _favoritedRestaurants;
  }

  @override
  Stream<List<PreorderBag>> customerPreordersStream(String customerId) async* {
    yield _preorders;
  }

  @override
  Future<List<Restaurant>> customerSwipe(String customerId) async {
    await Future.delayed(Duration.zero);
    return _swipeRestaurants;
  }

  @override
  Future<Restaurant?> restaurantGet(String restaurantId) async {
    await Future.delayed(Duration.zero);
    return _swipeRestaurants
        .where((restaurant) => restaurant.restaurantId == restaurantId)
        .first;
  }

  @override
  Future<MenuItem?> restaurantMenuItemGet(
      String restaurantId, String itemId) async {
    await Future.delayed(Duration.zero);
    return MenuItem(
      itemId: "01",
      itemName: "Item Name",
      itemPrice: 4,
      timestamp: Timestamp.now(),
      dietaryTags: ["Vegan"],
      itemImageRef: "test/images/menu_item.jpeg",
      itemDescription:
          "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
    );
  }

  @override
  Future<PopUpLocation?> restaurantLocationGet(
      String restaurantId, String locationId) async {
    await Future.delayed(Duration.zero);
    return PopUpLocation(
      locationId: "01",
      locationAddress: "Location Address, WA 12345",
      locationDateStart: Timestamp.now(),
      locationDateEnd: Timestamp.now(),
      timestamp: Timestamp.now(),
      geolocation: const GeoPoint(47.60, -122.33),
      locationName: "Location Name",
    );
  }

  @override
  Future<void> preorderCreate(
      String customerId, PreorderBag preorderBag) async {
    await Future.delayed(Duration.zero);
    _preorders.add(preorderBag);
  }

  @override
  Future<PreorderBag?> preorderGet(String preorderId) async {
    await Future.delayed(Duration.zero);
    return PreorderBag(
        preorderId: "ABCDE",
        restaurant: _favoritedRestaurants[0],
        location: _favoritedRestaurants[0].upcomingLocations[0],
        timestamp: Timestamp.now());
  }
}
