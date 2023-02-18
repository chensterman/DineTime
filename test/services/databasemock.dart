import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';

class DatabaseServiceMock extends DatabaseService {
  final List<Restaurant> _favoritedRestaurants =
      DataMock().favoritedRestaurants;
  final List<Restaurant> _swipeRestaurants = DataMock().swipeRestaurants;

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
      customerId: "123",
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

class DataMock {
  final List<Restaurant> favoritedRestaurants = [
    Restaurant(
      restaurantId: "0",
      restaurantName: "Steph Curry's Pop Up",
      restaurantLogoRef: "test/images/steph_curry_logo.png",
      pricing: 2,
      gallery: [
        GalleryImage(
          imageId: "01",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/gallery_image.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
      ],
      menu: [
        MenuItem(
          itemId: "01",
          itemName: "Item Name",
          itemPrice: 4,
          timestamp: Timestamp.now(),
          dietaryTags: ["Vegan"],
          itemImageRef: "test/images/menu_item.jpeg",
          itemDescription:
              "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
        ),
      ],
      upcomingLocations: [
        PopUpLocation(
          locationId: "01",
          locationAddress: "Location Address, WA 12345",
          locationDateStart: Timestamp.now(),
          locationDateEnd: Timestamp.now(),
          timestamp: Timestamp.now(),
          geolocation: const GeoPoint(47.60, 122.33),
          locationName: "Location Name",
        ),
      ],
      bio:
          "This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio.",
      cuisine: "Pastry",
    ),
  ];

  final List<Restaurant> swipeRestaurants = [
    Restaurant(
      restaurantId: "1",
      restaurantName: "David Dai's",
      restaurantLogoRef: "test/images/david_dais_logo.png",
      pricing: 2,
      gallery: [
        GalleryImage(
          imageId: "11",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/gallery_image.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
      ],
      menu: [
        MenuItem(
          itemId: "11",
          itemName: "Item Name",
          itemPrice: 4,
          timestamp: Timestamp.now(),
          dietaryTags: ["Vegan"],
          itemImageRef: "test/images/menu_item.jpeg",
          itemDescription:
              "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
        ),
      ],
      upcomingLocations: [
        PopUpLocation(
          locationId: "11",
          locationAddress: "Location Address, WA 12345",
          locationDateStart: Timestamp.now(),
          locationDateEnd: Timestamp.now(),
          timestamp: Timestamp.now(),
          geolocation: const GeoPoint(47.60, 122.33),
          locationName: "Location Name",
        ),
      ],
      bio:
          "This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio.",
      cuisine: "Chinese",
    ),
    Restaurant(
      restaurantId: "2",
      restaurantName: "Literal Dogshit",
      restaurantLogoRef: "test/images/literal_dogshit_logo.png",
      pricing: 2,
      gallery: [
        GalleryImage(
          imageId: "21",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/gallery_image.png",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
      ],
      menu: [
        MenuItem(
          itemId: "21",
          itemName: "Item Name",
          itemPrice: 4,
          timestamp: Timestamp.now(),
          dietaryTags: ["Vegan"],
          itemImageRef: "test/images/menu_item.png",
          itemDescription:
              "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
        ),
      ],
      upcomingLocations: [
        PopUpLocation(
          locationId: "21",
          locationAddress: "Location Address, WA 12345",
          locationDateStart: Timestamp.now(),
          locationDateEnd: Timestamp.now(),
          timestamp: Timestamp.now(),
          geolocation: const GeoPoint(47.60, 122.33),
          locationName: "Location Name",
        ),
      ],
      bio:
          "This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio.",
      cuisine: "Indian",
    ),
  ];
}
