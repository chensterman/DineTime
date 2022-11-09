import 'package:cloud_firestore/cloud_firestore.dart';

// Contains all methods and data pertaining to the user database
class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Access to 'users' collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Add user document to 'users' collection and initialize fields
  Future<void> createUser() async {
    await userCollection.doc(uid).set({
      'cuisine': null,
      'zipcode': null,
      'distances': null,
      'prices': null,
      'diets': null,
    });
  }

  // Update user data
  Future<void> updateUser(Map<String, dynamic> userData) async {
    await userCollection.doc(uid).update(userData);
  }
}
