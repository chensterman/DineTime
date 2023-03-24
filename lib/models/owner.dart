import 'package:dinetime_mobile_mvp/models/restaurant.dart';

// Customer data model (DineTime user as that is a customer)
class Owner {
  String ownerId;
  List<Restaurant> restaurants;
  Owner({
    required this.ownerId,
    required this.restaurants,
  });
}
