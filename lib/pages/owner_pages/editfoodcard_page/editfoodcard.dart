import 'package:dinetime_mobile_mvp/models/owner.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/owner_pages/editfoodcard_page/bloc/editfoodcard_bloc.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

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
  // File? coverPhoto;
  // File? _imageProfile;
  // List<File> _galleryImages = [];
  // List<File?> _newImages = List.generate(6, (_) => null);
  // File? _image;
  // final ImagePicker _picker = ImagePicker();
  // final ImagePicker _pickerProfile = ImagePicker();
  String _restaurantName = "";
  String _bio = "";
  String _cuisine = "";
  int _pricing = 1;
  bool _preordersEnabled = false;
  String? _email;
  String? _website;
  String? _instagramHandle;
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    // This allows us to intilize states of fields with constructor argument
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _restaurantName = widget.restaurant.restaurantName;
        _bio = widget.restaurant.bio;
        _cuisine = widget.restaurant.cuisine;
        _pricing = widget.restaurant.pricing;
        _preordersEnabled = widget.restaurant.preordersEnabled;
        _email = widget.restaurant.email;
        _website = widget.restaurant.website;
        _instagramHandle = widget.restaurant.instagramHandle;
        _phoneNumber = widget.restaurant.phoneNumber;
      });
    });
  }

  // void _editMenuItems(int index, MenuItem menuUpdates) {
  //   setState(() => editFields.menu[index] = menuUpdates);
  // }

  // void _addMenuItems(List<MenuItem> menuItems) {
  //   setState(() => menuItems.forEach((item) => editFields.menu.add(item)));
  // }

  // void getImage(int index) async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image == null) return;

  //   final imageTemporary = File(image.path);

  //   setState(() {
  //     if (index >= _newImages.length) {
  //       _newImages.add(imageTemporary);
  //     } else {
  //       _newImages[index] = imageTemporary;
  //     }
  //   });
  // }

  // void deleteImage(int index) {
  //   setState(() {
  //     if (_galleryImages.length > index) {
  //       _galleryImages.removeAt(index);
  //     }
  //     if (_newImages.length > index) {
  //       _newImages.removeAt(index);
  //     }
  //   });
  // }

  // Future<void> _getCoverImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       editFields.restaurantCoverRef =
  //           "${editFields.restaurantName}/gallery/${basename(pickedFile.path)}";
  //       coverPhoto = _image;
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  // void _deleteCoverImage() {
  //   setState(() {
  //     _image = null;
  //     editFields.restaurantCoverRef = "";
  //     coverPhoto = _image;
  //   });
  // }

  // Future<void> _getImageProfile() async {
  //   final pickedFile =
  //       await _pickerProfile.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageProfile = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  // void _deleteImageProfile() {
  //   setState(() {
  //     _imageProfile = null;
  //   });
  // }

  Future<List<Tuple2<String, File>>> _getGalleryPhotos(
      Services services, String restaurantId) async {
    Map<String, File> photoMap =
        await services.clientDB.restaurantGalleryGet(restaurantId);
    List<Tuple2<String, File>> myList = photoMap.entries
        .map((entry) => Tuple2(entry.key, entry.value))
        .cast<Tuple2<String, File>>()
        .toList();
    return myList;
  }

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
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
                    // TODO
                    EditCoverPhoto(
                      onTap: () {},
                      onDelete: () {},
                      image: null,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Photo Gallery",
                      style: dineTimeTypography.headlineMedium,
                    ),
                    const SizedBox(height: 20.0),
                    // TODO
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return EditGallery(
                          onTap: () {},
                          onDelete: () {},
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
                    // TODO
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
                              onTap: () {},
                              onDelete: () {},
                              image: null,
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
                    TextFormField(
                      initialValue: _restaurantName,
                      onChanged: (value) {
                        setState(() {
                          _restaurantName = value;
                        });
                      },
                      maxLength: 50,
                      style: const TextStyle(
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
                      "Cuisine Type",
                      style: dineTimeTypography.bodyMedium,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: _cuisine,
                      onChanged: (value) {
                        setState(() {
                          _cuisine = value;
                        });
                      },
                      maxLength: 50,
                      style: const TextStyle(
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
                      selected: _pricing,
                      onSelect: (value) {
                        setState(() {
                          _pricing = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    // Not used because cuisine type needs to be more custom
                    // CuisineType(),
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
                    TextFormField(
                      initialValue: _bio,
                      onChanged: (value) {
                        setState(() {
                          _bio = value;
                        });
                      },
                      maxLength: 1500,
                      style: const TextStyle(
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
                        const Spacer(),
                        CupertinoSwitch(
                          value: _preordersEnabled,
                          onChanged: (value) {
                            setState(() {
                              _preordersEnabled = value;
                            });
                          },
                          activeColor: dineTimeColorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    // TODO
                    // EditMenu(), TEMP REMOVE
                    const SizedBox(height: 20.0),
                    // TODO
                    AddMenuItem(),
                    const SizedBox(height: 20.0),
                    Text(
                      "Upcoming Locations",
                      style: dineTimeTypography.headlineMedium,
                    ),
                    const SizedBox(height: 20.0),
                    // TODO
                    EditUpcomingLocations(),
                    const SizedBox(height: 20.0),
                    // TODO
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
                    TextFormField(
                      initialValue: _email,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                      maxLength: 50,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'example@example.com',
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
                      "Website",
                      style: dineTimeTypography.bodyMedium,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: _website,
                      onChanged: (value) {
                        setState(() {
                          _website = value;
                        });
                      },
                      maxLength: 12,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'www.example.com',
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
                      "Instagram Handle",
                      style: dineTimeTypography.bodyMedium,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: _instagramHandle,
                      onChanged: (value) {
                        setState(() {
                          _instagramHandle = value;
                        });
                      },
                      maxLength: 12,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: '(Do not include the @)',
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
                    TextFormField(
                      initialValue: _phoneNumber,
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                      maxLength: 12,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: '123-456-7890',
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
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // TODO
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: dineTimeColorScheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(double.infinity, 45),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Save Changes',
                            style: dineTimeTypography.headlineSmall
                                ?.copyWith(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
