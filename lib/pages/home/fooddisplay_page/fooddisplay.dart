import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/foodcard.dart';
import 'package:flutter/material.dart';

class FoodDisplay extends StatelessWidget {
  final String restaurantId;
  final String customerId;
  final DatabaseService clientDB;
  final StorageService clientStorage;
  const FoodDisplay({
    required this.restaurantId,
    required this.customerId,
    required this.clientDB,
    required this.clientStorage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.08,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: clientDB.getRestaurant(restaurantId, customerId),
        builder: (context, AsyncSnapshot<Restaurant> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // On loaded, process into FoodListCard
            Restaurant restaurant = snapshot.data!;
            return Center(
              child: FoodCard(
                restaurant: restaurant,
                isFront: false,
                clientStorage: clientStorage,
              ),
            );
          } else if (snapshot.hasError) {
            // On error
            return const Text('Error');
          } else {
            // While still loading, return loading version of FoodListCard
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
