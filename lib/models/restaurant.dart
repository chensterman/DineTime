import 'package:flutter/material.dart';

// Restaurant data model
class Restaurant {
  final String? name;
  final String? address;
  final String? website;
  final String? phoneNumber;
  final ImageProvider<Object>? image;
  final int? priceLevel;
  final num? rating;
  final bool? openNow;

  Restaurant({
    this.name,
    this.address,
    this.website,
    this.phoneNumber,
    this.image,
    this.priceLevel,
    this.rating,
    this.openNow,
  });
}
