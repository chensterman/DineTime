import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:flutter/material.dart';

import 'foodlistcard.dart';

// Widget that contains the FutureBuilder to process saved restaurant document references
class FoodListCardProcess extends StatelessWidget {
  final GeoPoint customerGeoPoint;
  final DocumentReference restaurantRef;
  const FoodListCardProcess({
    super.key,
    required this.customerGeoPoint,
    required this.restaurantRef,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Future to retrieve document data of restaurant reference
      future: DatabaseService().getRestaurantPreview(restaurantRef.id),
      builder: (context, AsyncSnapshot<RestaurantPreview> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // On loaded, process into FoodListCard
          RestaurantPreview restaurantPreview = snapshot.data!;
          return FoodListCard(
            isLoading: false,
            customerGeoPoint: customerGeoPoint,
            restaurantPreview: restaurantPreview,
          );
        } else if (snapshot.hasError) {
          // On error
          return const Text('Error');
        } else {
          // While still loading, return loading version of FoodListCard
          return const FoodListCard(isLoading: true);
        }
      },
    );
  }
}
