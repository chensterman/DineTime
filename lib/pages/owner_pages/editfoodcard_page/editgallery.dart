import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/fooddisplay_page/fooddisplay.dart';
import 'package:dinetime_mobile_mvp/pages/owner_pages/editfoodcard_page/cuisineselection.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'menuitemphoto.dart';
import 'cuisineselection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

// Cards that display list items in saved
class EditGallery extends StatefulWidget {
  const EditGallery({
    Key? key,
  }) : super(key: key);

  @override
  _EditGalleryState createState() => _EditGalleryState();
}

class _EditGalleryState extends State<EditGallery> {
  final double _cardHeight = 75.0;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _selectedOption = '';
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();
  final textController4 = TextEditingController();
  List<String> imageAssets = [
    "lib/assets/vegan.png",
    "lib/assets/vegetarian.png",
    "lib/assets/pescatarian.png",
    "lib/assets/paleo.png",
    "lib/assets/keto.png",
    "lib/assets/nut_free.png",
  ];
  List<String> cuisineTypes = [
    "Vegan",
    "Vegetarian",
    "Pescatarian",
    "Paleo",
    "Keto",
    "Nut Free",
  ];

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  void _onSelectOption(String options) {
    setState(() {
      _selectedOption = options;
    });
  }

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return SizedBox(
      height: 70,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(0, -3),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(3, 0),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(-3, 0),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 25.0,
                      bottom: 0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_rounded, size: 30),
                              color: dineTimeColorScheme.primary,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Add Gallery Photo",
                                      style: dineTimeTypography.headlineLarge,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                MenuItemPhoto(
                                  onTap: _getImage,
                                  onDelete: _deleteImage,
                                  image: _image,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Add a picture",
                                  style: dineTimeTypography.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: dineTimeTypography.bodyMedium,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextField(
                                  controller: textController2,
                                  maxLength: 300,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Write a description',
                                    fillColor: Color(0xFFF6F6F6),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 10,
                                  cursorColor: dineTimeColorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: dineTimeColorScheme.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(45, 45),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Done',
                                      style: dineTimeTypography.headlineSmall
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(45, 45),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Delete Photo',
                                      style: dineTimeTypography.headlineSmall
                                          ?.copyWith(
                                              fontSize: 16.0,
                                              color:
                                                  dineTimeColorScheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: DottedBorder(
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
        ),
      ),
    );
  }
}
