import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'editgallery.dart';
import 'editcoverphoto.dart';
import 'editprofilepic.dart';
import 'priceoption.dart';
import 'editmenu.dart';
import 'editcuisinetype.dart';
import 'addmenuitem.dart';
import 'editupcominglocations.dart';
import 'addupcominglocations.dart';
import 'cuisineselection.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';

class EditFoodCard extends StatefulWidget {
  final Restaurant restaurant;
  const EditFoodCard({
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  State<EditFoodCard> createState() => _EditFoodCardState();
}

class _EditFoodCardState extends State<EditFoodCard> {
  List<File> _images = [];
  List<File?> _newImages = List.generate(6, (_) => null);
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();
  final textController4 = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  File? _imageProfile;
  final ImagePicker _pickerProfile = ImagePicker();
  bool _switchValue = false;
  final List<String> colorOptions = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];
  String _selectedOption = '';

  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void getImage(int index) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      if (index >= _newImages.length) {
        _newImages.add(imageTemporary);
      } else {
        _newImages[index] = imageTemporary;
      }
    });
  }

  void deleteImage(int index) {
    setState(() {
      if (_images.length > index) {
        _images.removeAt(index);
      }
      if (_newImages.length > index) {
        _newImages.removeAt(index);
      }
    });
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
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

  Future<void> _getImageProfile() async {
    final pickedFile =
        await _pickerProfile.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageProfile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _deleteImageProfile() {
    setState(() {
      _imageProfile = null;
    });
  }

  void _onSelectOption(String options) {
    setState(() {
      _selectedOption = options;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Services services = Provider.of<Services>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cover Photo",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                EditCoverPhoto(
                  onTap: _getImage,
                  onDelete: _deleteImage,
                  image: _image,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Photo Gallery",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return EditGallery(
                      onTap: () => getImage(index),
                      onDelete: () => deleteImage(index),
                      image: _images.length > index ? _images[index] : null,
                      newImage:
                          _newImages.length > index ? _newImages[index] : null,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tap to Edit or Replace Photos',
                      style: dineTimeTypography.labelMedium?.copyWith(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Business Information",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Profile Picture",
                          style: dineTimeTypography.bodySmall,
                        ),
                        const SizedBox(height: 10.0),
                        EditProfilePic(
                          onTap: _getImageProfile,
                          onDelete: _deleteImageProfile,
                          image: _imageProfile,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Business Name",
                  style: dineTimeTypography.bodyMedium,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: textController,
                  maxLength: 50,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your text here',
                    fillColor: Color(0xFFF6F6F6),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 1,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Price Range",
                  style: dineTimeTypography.bodyMedium,
                ),
                const SizedBox(height: 20.0),
                PriceOption(
                  options: colorOptions,
                  onSelect: _onSelectOption,
                ),
                const SizedBox(height: 20.0),
                CuisineType(),
                const SizedBox(height: 20.0),
                Text(
                  "Our Story",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "About",
                  style: dineTimeTypography.bodyMedium,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: textController2,
                  maxLength: 1500,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Our Story',
                    fillColor: Color(0xFFF6F6F6),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: 20,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Our Menu",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      "Enable Preorders",
                      style: dineTimeTypography.bodyMedium,
                    ),
                    Spacer(),
                    CupertinoSwitch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                      activeColor: dineTimeColorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                EditMenu(),
                const SizedBox(height: 20.0),
                AddMenuItem(),
                const SizedBox(height: 20.0),
                Text(
                  "Upcoming Locations",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                EditUpcomingLocations(),
                const SizedBox(height: 20.0),
                AddUpcomingLocations(),
                const SizedBox(height: 20.0),
                Text(
                  "General Information",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Email",
                  style: dineTimeTypography.bodyMedium,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: textController3,
                  maxLength: 50,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'stephcurry@gmail.com',
                    fillColor: Color(0xFFF6F6F6),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 1,
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Phone Number",
                  style: dineTimeTypography.bodyMedium,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: textController4,
                  maxLength: 12,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: '425-979-6447',
                    fillColor: Color(0xFFF6F6F6),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 1,
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
