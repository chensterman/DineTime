import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Contains all methods and data pertaining to the user database
class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Access to 'users' collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Create user:
  //  Add user document to 'users' and initialize fields.
  Future<int> createUser() async {
    try {
      await userCollection.doc(uid).set({
        'cuisine': null,
        'zipcode': null,
        'distance-min': null,
        'distance-max': null,
        'price': null,
        'dietary': null,
      });
      return 0;
    } catch (e) {
      return 1;
    }
  }

  Future<int> updateUser(Map<String, dynamic> userData) async {
    try {
      await userCollection
          .doc(uid)
          .update(userData)
          .then((value) => print("User updated"))
          .catchError((error) => print("Failed"));
      return 0;
    } catch (e) {
      return 1;
    }
  }
}
