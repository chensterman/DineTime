import 'package:cloud_firestore/cloud_firestore.dart';

// Customer data model (DineTime user as that is a customer)
class Customer {
  String customerId;
  GeoPoint? geolocation;
  Customer({
    required this.customerId,
    required this.geolocation,
  });
}
