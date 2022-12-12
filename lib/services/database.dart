import 'package:cloud_firestore/cloud_firestore.dart';

// Contains all methods and data pertaining to the user database
class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Access to 'customers' collection
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customers');

  // Add user document to 'users' collection and initialize fields
  Future<void> createUser() async {
    await customerCollection.doc(uid).set({
      'geolocation': null,
      'saved_businesses': [],
    });
  }

  // Update user data
  Future<void> updateUser(Map<String, dynamic> userData) async {
    await customerCollection.doc(uid).update(userData);
  }
}
