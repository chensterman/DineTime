import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';

class StorageServiceMock implements StorageService {
  @override
  Future<ImageProvider<Object>> getPhoto(String photoPath) async {
    await Future.delayed(Duration.zero);
    ImageProvider<Object> photo = AssetImage(photoPath);
    return photo;
  }
}
