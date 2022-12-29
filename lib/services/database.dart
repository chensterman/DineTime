import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Contains all methods and data pertaining to the user database
class DatabaseService {
  // Firebase Storage instance.
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Access to 'restaurants' collection
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');
  // Access to 'customers' collection
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customers');

  // Retrieves the stored image from a given reference to Firebase Storage.
  Future<ImageProvider<Object>> getPhoto(String photoPath) async {
    ImageProvider<Object> photo;
    Uint8List? photoData = await _storage.ref().child(photoPath).getData();
    if (photoData == null) {
      photo = const AssetImage('lib/assets/dinetime-orange.png');
    } else {
      photo = MemoryImage(photoData);
    }
    return photo;
  }

  /* CUSTOMER FIRESTORE INTERACTIONS */

  // Add user document to 'users' collection and initialize fields
  Future<void> createCustomer(String customerId) async {
    await customerCollection.doc(customerId).set({
      'geolocation': null,
      'saved_businesses': [],
    });
  }

  // Update user data
  Future<void> updateCustomer(
      String customerId, Map<String, dynamic> customerData) async {
    await customerCollection.doc(customerId).update(customerData);
  }

  // Stream of specific customer document
  Stream<DocumentSnapshot> customerStream(String customerId) {
    return customerCollection.doc(customerId).snapshots();
  }

  /* RESTAURANT FIRESTORE INTERACTIONS */

  // Retrieves a data from a restaurant to obtain a RestaurantPreview object
  Future<RestaurantPreview> getRestaurantPreview(String restaurantId) async {
    // Retrieve restaurant document data
    DocumentSnapshot restaurantSnapshot =
        await restaurantCollection.doc(restaurantId).get();
    Map<String, dynamic> restaurantData =
        restaurantSnapshot.data() as Map<String, dynamic>;
    // Isolate all fields
    String restaurantName = restaurantData['restaurant_name'];
    String photoPath = restaurantData['logo_location'];
    ImageProvider<Object> restaurantLogo = await getPhoto(photoPath);
    List restaurantLocationDataRaw = restaurantData['upcoming_locations'];
    int pricing = restaurantData['pricing'];
    String? cuisine = restaurantData['cuisine'];
    String? instagramHandle = restaurantData['instagram_handle'];
    String? website = restaurantData['website'];
    // Refactor location data into a list of PopUpLocation objects
    List<PopUpLocation> restaurantLocationData = [];
    for (Object location in restaurantLocationDataRaw) {
      Map<String, dynamic> locationMap = location as Map<String, dynamic>;
      restaurantLocationData.add(PopUpLocation(
          locationId: locationMap['location_id'],
          locationAddress: locationMap['address'],
          locationDateStart: locationMap['date_start'],
          locationDateEnd: locationMap['date_end'],
          dateAdded: locationMap['date_added'],
          geocode: locationMap['geocode']));
    }
    // Construct and return RestaurantPreview object
    return RestaurantPreview(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        restaurantLogo: restaurantLogo,
        upcomingLocations: restaurantLocationData,
        pricing: pricing,
        cuisine: cuisine,
        instagramHandle: instagramHandle,
        website: website);
  }
}
