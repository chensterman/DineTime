import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:flutter/material.dart';

import 'foodlistcard.dart';

// Widget that contains the FutureBuilder to process saved restaurant document references
class FoodListCardProcess extends StatelessWidget {
  final String customerId;
  final DocumentReference restaurantRef;
  final StorageService clientStorage;
  final DatabaseService clientDB;
  const FoodListCardProcess({
    super.key,
    required this.customerId,
    required this.restaurantRef,
    required this.clientStorage,
    required this.clientDB,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Future to retrieve document data of restaurant reference
      future: clientDB.getRestaurantPreview(restaurantRef.id, customerId),
      builder: (context, AsyncSnapshot<RestaurantPreview> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // On loaded, process into FoodListCard
          RestaurantPreview restaurantPreview = snapshot.data!;
          return FoodListCard(
            isLoading: false,
            customerId: customerId,
            restaurantPreview: restaurantPreview,
            clientStorage: clientStorage,
            clientDB: clientDB,
          );
        } else if (snapshot.hasError) {
          // On error
          return const Text('Error');
        } else {
          // While still loading, return loading version of FoodListCard
          return FoodListCard(
            isLoading: true,
            customerId: customerId,
            clientStorage: clientStorage,
            clientDB: clientDB,
          );
        }
      },
    );
  }
}
