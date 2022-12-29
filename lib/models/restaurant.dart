import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Restaurant data model
class Restaurant {
  String restaurantId;
  String restaurantName;
  ImageProvider<Object> restaurantLogo;
  int pricing;
  List<GalleryImage> gallery;
  Menu menu;
  List<PopUpLocation> upcomingLocations;
  String? bio;
  String? cuisine;
  String? website;
  String? instagramHandle;

  Restaurant({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.pricing,
    required this.gallery,
    required this.menu,
    required this.upcomingLocations,
    this.bio,
    this.cuisine,
    this.website,
    this.instagramHandle,
  });
}

// Restaurant preview class that only displays necessary data for the saved list cards
class RestaurantPreview {
  String restaurantId;
  String restaurantName;
  ImageProvider<Object> restaurantLogo;
  List<PopUpLocation> upcomingLocations;
  int pricing;
  String? cuisine;
  String? instagramHandle;
  String? website;

  RestaurantPreview({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.upcomingLocations,
    required this.pricing,
    this.cuisine,
    this.instagramHandle,
    this.website,
  });
}

// Gallery image data model for restaurants
class GalleryImage {
  String imageId;
  ImageProvider<Object> image;
  Timestamp dateAdded;

  GalleryImage({
    required this.imageId,
    required this.image,
    required this.dateAdded,
  });
}

// Menu data model for restaurants
class Menu {
  String menuId;
  String menuName;
  List<MenuItem> menuItems;
  Timestamp dateAdded;

  Menu({
    required this.menuId,
    required this.menuName,
    required this.menuItems,
    required this.dateAdded,
  });
}

// Menu item data model for menus
class MenuItem {
  String itemId;
  String itemName;
  num itemPrice;
  Timestamp dateAdded;
  ImageProvider<Object>? itemPhoto;
  String? itemDescription;

  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.dateAdded,
    this.itemPhoto,
    this.itemDescription,
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

  PopUpLocation({
    required this.locationId,
    required this.locationAddress,
    required this.locationDateStart,
    required this.locationDateEnd,
    required this.dateAdded,
    required this.geocode,
  });
}
