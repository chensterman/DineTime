import 'package:flutter/material.dart';

// Restaurant data model
class Restaurant {
  // Location link?
  final String? phoneNumber;
  final String? websiteURL;
  final ImageProvider<Object>? image;
  final String? name;
  final String? cuisine;
  final int? priceLevel;
  // final String? dineIn;
  // final double? rating;
  // final int? numRatings;
  final double? distance;
  final String? openHours;
  final List<ImageProvider<Object>>? featuredPhotos;
  final List<String>? dietaryOptions;

  Restaurant({
    this.phoneNumber,
    this.websiteURL,
    this.image,
    this.name,
    this.cuisine,
    this.priceLevel,
    this.distance,
    this.openHours,
    this.featuredPhotos,
    this.dietaryOptions,
  });
}
