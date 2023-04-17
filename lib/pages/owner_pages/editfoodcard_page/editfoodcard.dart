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
  State<EditFoodCard> createState() => _EditFoodCardState(restaurant);
}

class _EditFoodCardState extends State<EditFoodCard> {
  Restaurant editFields;
  File? coverPhoto;
  File? _imageProfile;
  List<File> _galleryImages = [];
  List<File?> _newImages = List.generate(6, (_) => null);
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();
  final textController4 = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final ImagePicker _pickerProfile = ImagePicker();
  final List<String> colorOptions = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];
  String _selectedOption = '';
  _EditFoodCardState(this.editFields);
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
      if (_galleryImages.length > index) {
        _galleryImages.removeAt(index);
      }
      if (_newImages.length > index) {
        _newImages.removeAt(index);
      }
    });
  }

  Future<void> _getCoverImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        editFields.restaurantCoverRef =
            "${editFields.restaurantName}/gallery/${basename(pickedFile.path)}";
        coverPhoto = _image;
      } else {
        print('No image selected.');
      }
    });
  }

  void _deleteCoverImage() {
    setState(() {
      _image = null;
      editFields.restaurantCoverRef = "";
      coverPhoto = _image;
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
                FutureBuilder(
                  future: services.clientDB
                      .restaurantCoverPhotoGet(editFields.restaurantId),
                  builder: (context, snapshot) {
                    return EditCoverPhoto(
                      onTap: _getCoverImage,
                      onDelete: _deleteCoverImage,
                      image: snapshot.data,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Photo Gallery",
                  style: dineTimeTypography.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                FutureBuilder(
                    future:
                        _getGalleryPhotos(services, editFields.restaurantId),
                    builder: (context, snapshot) {
                      return GridView.builder(
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
                            image: _galleryImages.length > index
                                ? snapshot.data![index].item2
                                : null,
                          );
                        },
                      );
                    }),
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
                TextFormField(
                  maxLength: 50,
                  initialValue: editFields.restaurantName,
                  onChanged: (value) {
                    editFields.restaurantName = value;
                  },
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
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
                  onSelect: (value) {
                    _onSelectOption;
                  },
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
                TextFormField(
                  maxLength: 1500,
                  initialValue: editFields.bio,
                  onChanged: (value) {
                    context.read<EditFoodCardBloc>().add(EditFoodCardUpdateBio(
                          newBio: value,
                        ));
                  },
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
                      value: editFields.displayed ?? false,
                      onChanged: (value) {
                        setState(() {
                          editFields.displayed = value;
                          print(editFields.displayed);
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
                TextFormField(
                  maxLength: 50,
                  initialValue: editFields.email ?? "",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
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
                  initialValue: editFields.phoneNumber ?? "",
                  maxLength: 12,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
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
