import 'package:cloud_firestore/cloud_firestore.dart';

// Restaurant data model
class Restaurant {
  String restaurantId;
  String restaurantName;
  String bio;
  String cuisine;
  String restaurantLogoRef;
  int pricing;
  List<GalleryImage> gallery;
  List<MenuItem> menu;
  List<PopUpLocation> upcomingLocations;
  String? website;
  String? instagramHandle;
  String? email;
  Restaurant({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogoRef,
    required this.pricing,
    required this.gallery,
    required this.menu,
    required this.upcomingLocations,
    required this.bio,
    required this.cuisine,
    this.website,
    this.instagramHandle,
    this.email,
  });
}

// Gallery image data model for restaurants
class GalleryImage {
  String imageId;
  String imageRef;
  String imageName;
  String imageDescription;
  Timestamp timestamp;
  GalleryImage({
    required this.imageId,
    required this.imageDescription,
    required this.imageRef,
    required this.timestamp,
    required this.imageName,
  });
}

// Menu item data model for menus
class MenuItem {
  String itemId;
  String itemName;
  num itemPrice;
  Timestamp timestamp;
  List dietaryTags;
  String itemImageRef;
  String itemDescription;
  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.timestamp,
    required this.dietaryTags,
    required this.itemImageRef,
    required this.itemDescription,
  });
}

// Pop-up location data model for restaurants
class PopUpLocation {
  String locationId;
  String locationAddress;
  Timestamp locationDateStart;
  Timestamp locationDateEnd;
  Timestamp timestamp;
  GeoPoint geolocation;
  String locationName;
  PopUpLocation({
    required this.locationId,
    required this.locationAddress,
    required this.locationDateStart,
    required this.locationDateEnd,
    required this.timestamp,
    required this.geolocation,
    required this.locationName,
  });
}

Map<String, String> dietToImagePath = {
  "Vegan": "lib/assets/vegan.png",
  "Vegetarian": "lib/assets/vegetarian.png",
  "Nut Free": "lib/assets/nut_free.png",
};
