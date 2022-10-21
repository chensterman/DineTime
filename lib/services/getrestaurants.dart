import 'dart:convert';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GetRestaurants {
  // Instantiate necessary info
  final _placesBaseUrl = 'maps.googleapis.com';
  final _type = 'restaurant';
  final _apiKey = 'AIzaSyBst1M7v8k_qtkiYAO-zN2YIUIYd_QjBy8';
  final _client = http.Client();

  // Retrieve restaurant Ids from Google Places API
  Future<dynamic> getPlaces(
      double lat, double lon, int radius, String keyword, int maxPrice) async {
    Map<String, dynamic> queryParams = {
      'location': '$lat $lon',
      'radius': radius.toString(),
      'keyword': keyword,
      'maxprice': maxPrice.toString(),
      'type': _type,
      'key': _apiKey,
    };
    String unencodedPath = 'maps/api/place/nearbysearch/json';
    Uri uri = Uri.https(_placesBaseUrl, unencodedPath, queryParams);
    Response response = await _client.get(uri);
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      List<Restaurant> restaurants = [];
      List results = data['results'];
      for (dynamic result in results) {
        String placeId = result['place_id'];
        dynamic placeDetails = await _getPlacesDetails(placeId);
        Restaurant restaurant = Restaurant(
          name: placeDetails['name'],
          address: placeDetails['address'],
          website: placeDetails['website'],
          phoneNumber: placeDetails['phone_number'],
          image: placeDetails['image'],
          priceLevel: placeDetails['price_level'],
          rating: placeDetails['rating'],
          openNow: placeDetails['open_now'],
        );
        restaurants.add(restaurant);
      }
      return {'status': response.statusCode, 'restaurants': restaurants};
    } else {
      return {'status': response.statusCode};
    }
  }

  // Retrieve restaurant details from Google Places API
  Future<dynamic> _getPlacesDetails(String placeId) async {
    Map<String, dynamic> queryParams = {
      'place_id': placeId,
      'key': _apiKey,
    };
    String unencodedPath = 'maps/api/place/details/json';
    Uri uri = Uri.https(_placesBaseUrl, unencodedPath, queryParams);
    Response response = await _client.get(uri);
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      dynamic result = {};
      if (data['result'] != null) {
        result = data['result'];
      }
      String? name = result['name'];
      String? address = result['formatted_address'];
      String? website = result['website'];
      String? phoneNumber = result['formatted_phone_number'];
      bool? openNow;
      if (result['opening_hours'] != null) {
        openNow = result['opening_hours']['open_now'];
      }
      ImageProvider<Object>? image =
          Image.asset('lib/assets/dinetime-orange.png').image;
      if (result['photos'].length != 0) {
        image = _getPhoto(result['photos'][0]['photo_reference']);
      }
      int? priceLevel = result['price_level'];
      num? rating = result['rating'];
      return {
        'status': response.statusCode,
        'name': name,
        'address': address,
        'website': website,
        'phone_number': phoneNumber,
        'open_now': openNow,
        'image': image,
        'price_level': priceLevel,
        'rating': rating,
      };
    } else {
      return {'status': response.statusCode};
    }
  }

  // Convert photo reference to image
  NetworkImage _getPhoto(String photoRef) {
    String urlRaw =
        '$_placesBaseUrl?photo_reference=$photoRef&maxwidth=250&maxheight=250&key=$_apiKey';
    return NetworkImage(urlRaw);
  }
}
