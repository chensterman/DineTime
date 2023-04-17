import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class EditGallery extends StatelessWidget {
  final File? image;
  final File? newImage;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const EditGallery({
    Key? key,
    required this.onTap,
    required this.onDelete,
    this.image,
    this.newImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageToDisplay = image;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: imageToDisplay != null
                  ? Image.file(
                      imageToDisplay,
                      fit: BoxFit.cover,
                    )
                  : DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10.0),
                      dashPattern: [5, 5],
                      strokeWidth: 2.0,
                      color: Colors.grey,
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (imageToDisplay != null)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
