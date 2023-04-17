import 'dart:io';

import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:flutter/material.dart';

// Customer data model (DineTime user as that is a customer)
class Owner {
  String ownerId;
  List<Restaurant> restaurants;
  Owner({
    required this.ownerId,
    required this.restaurants,
  });
}

class EditFood {
  File? coverPhoto;
  List<File>? photoGallery;
  File? profilePicture;
  String? name;
  int? priceRange;
  String? cuisineType;
  String? ourStory;
  bool? enablePreorders;
  List<MenuItem>? menuItems;
  List<PopUpLocation>? upcomingLocations;
  String? email;
  String? phoneNumber;
  EditFood({
    Key? key,
    this.coverPhoto,
    this.photoGallery,
    this.profilePicture,
    this.name,
    this.priceRange,
    this.cuisineType,
    this.ourStory,
    this.enablePreorders,
    this.menuItems,
    this.upcomingLocations,
    this.email,
    this.phoneNumber,
  });
  void updateEditFood(EditFood newFood, String updateType) {
    if (updateType == "cover_photo") {
      coverPhoto = newFood.coverPhoto!;
    } else if (updateType == "photo_gallery") {
      photoGallery = newFood.photoGallery!;
    } else if (updateType == "profile_picture") {
      profilePicture = newFood.profilePicture!;
    } else if (updateType == "business_name") {
      name = newFood.name!;
    } else if (updateType == "price_range") {
      priceRange = newFood.priceRange!;
    } else if (updateType == "cuisine_type") {
      cuisineType = newFood.cuisineType!;
    } else if (updateType == "our_story") {
      ourStory = newFood.ourStory!;
    } else if (updateType == "enable_preorders") {
      enablePreorders = newFood.enablePreorders!;
    } else if (updateType == "menu_items") {
      menuItems = newFood.menuItems!;
    } else if (updateType == "upcoming_locations") {
      upcomingLocations = newFood.upcomingLocations!;
    } else if (updateType == "email") {
      email = newFood.email!;
    } else if (updateType == "phone_number") {
      phoneNumber = newFood.phoneNumber!;
    }
  }
}
