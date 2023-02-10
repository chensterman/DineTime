import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Restaurant data model
class Restaurant {
  String restaurantId;
  String restaurantName;
  String bio;
  String cuisine;
  ImageProvider<Object> restaurantLogo;
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
    required this.restaurantLogo,
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

// Restaurant preview class that only displays necessary data for the saved list cards
class RestaurantPreview {
  String restaurantId;
  String restaurantName;
  ImageProvider<Object> restaurantLogo;
  List<PopUpLocation> upcomingLocations;
  int pricing;
  String cuisine;
  String? instagramHandle;
  String? website;
  String? email;

  RestaurantPreview({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.upcomingLocations,
    required this.pricing,
    required this.cuisine,
    this.instagramHandle,
    this.website,
    this.email,
  });
}

// Gallery image data model for restaurants
class GalleryImage {
  String imageId;
  String imageDescription;
  ImageProvider<Object> image;
  Timestamp dateAdded;
  String imageName;

  GalleryImage({
    required this.imageId,
    required this.imageDescription,
    required this.image,
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
  ImageProvider<Object> itemPhoto;
  String itemDescription;

  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.dateAdded,
    required this.dietaryTags,
    required this.itemPhoto,
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

  PopUpLocation({
    required this.locationId,
    required this.locationAddress,
    required this.locationDateStart,
    required this.locationDateEnd,
    required this.dateAdded,
    required this.geocode,
    required this.name,
  });
}

Map<String, String> dietToImagePath = {
  "Vegan": "lib/assets/vegan.png",
  "Vegetarian": "lib/assets/vegetarian.png",
  "Nut Free": "lib/assets/nut_free.png",
};
