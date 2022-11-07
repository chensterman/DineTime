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
  Future<void> createUser() async {
    await userCollection
        .doc(uid)
        .set({
          'cuisine': null,
          'zipcode': null,
          'distance-min': null,
          'distance-max': null,
          'price': null,
          'dietary': null,
        })
        .then((value) => print("User added"))
        .catchError((error) => print("Failed"));
  }
}
