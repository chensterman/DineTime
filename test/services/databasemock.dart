import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';

class DatabaseServiceMock extends DatabaseService {
  List<Restaurant> _favoritedRestaurants = [];
  List<Restaurant> _swipeRestaurants = [];

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
  Future<Customer?> customerGet(String customerId) async {
    await Future.delayed(Duration.zero);
    return Customer(
      customerId: customerId,
      geolocation: const GeoPoint(47.60, 122.33),
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
}
