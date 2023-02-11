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
  num? distance;

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
    this.distance,
  });
}

// Restaurant preview class that only displays necessary data for the saved list cards
class RestaurantPreview {
  String restaurantId;
  String restaurantName;
  String restaurantLogoRef;
  List<PopUpLocation> upcomingLocations;
  int pricing;
  String cuisine;
  String? instagramHandle;
  String? website;
  String? email;
  num? distance;

  RestaurantPreview({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogoRef,
    required this.upcomingLocations,
    required this.pricing,
    required this.cuisine,
    this.instagramHandle,
    this.website,
    this.email,
    this.distance,
  });
}

// Gallery image data model for restaurants
class GalleryImage {
  String imageId;
  String imageRef;
  String imageName;
  String imageDescription;
  Timestamp dateAdded;

  GalleryImage({
    required this.imageId,
    required this.imageDescription,
    required this.imageRef,
    required this.dateAdded,
    required this.imageName,
  });
}

// Menu item data model for menus
class MenuItem {
  String itemId;
  String itemName;
  num itemPrice;
  Timestamp dateAdded;
  List dietaryTags;
  String itemImageRef;
  String itemDescription;

  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.dateAdded,
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
  Timestamp dateAdded;
  GeoPoint geocode;
  String name;
  num? distance;

  PopUpLocation({
    required this.locationId,
    required this.locationAddress,
    required this.locationDateStart,
    required this.locationDateEnd,
    required this.dateAdded,
    required this.geocode,
    required this.name,
    this.distance,
  });
}

Map<String, String> dietToImagePath = {
  "Vegan": "lib/assets/vegan.png",
  "Vegetarian": "lib/assets/vegetarian.png",
  "Nut Free": "lib/assets/nut_free.png",
};
