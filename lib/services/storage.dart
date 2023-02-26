import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'services.dart';

class StorageServiceApp implements StorageService {
  // Firebase Storage instance.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Retrieves the stored image from a given reference to Firebase Storage.
  @override
  Future<ImageProvider<Object>> getPhoto(String photoPath) async {
    String photoURL = await _storage.ref().child(photoPath).getDownloadURL();
    return NetworkImage(photoURL);
  }
}
