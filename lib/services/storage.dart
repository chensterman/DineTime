import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  // Firebase Storage instance.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Retrieves the stored image from a given reference to Firebase Storage.
  Future<ImageProvider<Object>> getPhoto(String photoPath) async {
    ImageProvider<Object> photo;
    Uint8List? photoData = await _storage.ref().child(photoPath).getData();
    if (photoData == null) {
      photo = const AssetImage('lib/assets/dinetime-orange.png');
    } else {
      photo = MemoryImage(photoData);
    }
    return photo;
  }
}
