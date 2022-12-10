import 'package:cloud_firestore/cloud_firestore.dart';

// Customer data model
class Customer {
  String customerId;
  GeoPoint geolocation;

  Customer({
    required this.customerId,
    required this.geolocation,
  });
}

// Saved restaurant object data model
class SavedObject {
  String saveId;
  DocumentReference saveRef;
  Timestamp dateAdded;

  SavedObject({
    required this.saveId,
    required this.saveRef,
    required this.dateAdded,
  });
}
