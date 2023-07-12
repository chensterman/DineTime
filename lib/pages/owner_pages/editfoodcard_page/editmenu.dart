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

// Cards that display list items in saved
class EditMenu extends StatefulWidget {
  const EditMenu({
    Key? key,
  }) : super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
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
                                      "Edit Menu Item",
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
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Item Name",
                                      style: dineTimeTypography.bodySmall,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextField(
                                  controller: textController1,
                                  maxLength: 50,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Vegetable Samosas',
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
                                  minLines: 1,
                                  maxLines: 1,
                                  cursorColor: dineTimeColorScheme.primary,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: dineTimeTypography.bodySmall,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextField(
                                  controller: textController2,
                                  maxLength: 200,
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
                                  minLines: 3,
                                  maxLines: 5,
                                  cursorColor: dineTimeColorScheme.primary,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Price",
                                          style: dineTimeTypography.bodySmall,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: TextField(
                                            controller: textController3,
                                            maxLength: 20,
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 14,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: '\$0.00',
                                              fillColor: Color(0xFFF6F6F6),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: 1,
                                            cursorColor:
                                                dineTimeColorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dietary Tags",
                                          style: dineTimeTypography.bodySmall,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(20.0),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.9,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20.0,
                                                      right: 0,
                                                      top: 25.0,
                                                      bottom: 0,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .arrow_back_rounded,
                                                                size: 30,
                                                              ),
                                                              color:
                                                                  dineTimeColorScheme
                                                                      .primary,
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                            ),
                                                          ],
                                                        ),
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 12.0,
                                                                  right: 12.0,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Select Dietary Tags",
                                                                          style:
                                                                              dineTimeTypography.headlineLarge,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5.0),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Choose up to 3 tags",
                                                                          style: dineTimeTypography
                                                                              .bodyLarge
                                                                              ?.copyWith(
                                                                            color:
                                                                                dineTimeColorScheme.primary,
                                                                            fontSize:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            30.0),
                                                                    ListView
                                                                        .separated(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemCount:
                                                                          cuisineTypes
                                                                              .length,
                                                                      separatorBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        return SizedBox(
                                                                            height:
                                                                                20.0); // Add a SizedBox with a height of 10
                                                                      },
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        return CuisineSelection(
                                                                          cuisineName:
                                                                              cuisineTypes[index],
                                                                          imageAsset:
                                                                              imageAssets[index],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Center(
                                                                child:
                                                                    FractionallySizedBox(
                                                                  widthFactor:
                                                                      0.9,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          dineTimeColorScheme
                                                                              .primary,
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      minimumSize: Size(
                                                                          double
                                                                              .infinity,
                                                                          45),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            'Done',
                                                                            style:
                                                                                dineTimeTypography.headlineSmall?.copyWith(color: Colors.white, fontSize: 16.0),
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
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: SizedBox(
                                            width: 170,
                                            height: 57,
                                            child: Container(
                                              height: 40,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF6F6F6),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Choose dietary tags',
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 22.0),
                                      ],
                                    ),
                                  ],
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
                                      'Delete Item',
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
          child: SizedBox(
            height: _cardHeight,
            child: Row(
              children: <Widget>[
                SizedBox(width: 4.0),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 55.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Image.asset(
                            'lib/assets/preorderphoto2.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              'Vegetable Samosas',
                              style: dineTimeTypography.headlineSmall
                                  ?.copyWith(fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Flexible(
                            child: Text(
                              "\$9.99  ·  Vegan, Nut Free",
                              style: dineTimeTypography.bodySmall?.copyWith(
                                color: dineTimeColorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.edit_outlined,
                  color: dineTimeColorScheme.primary,
                ),
                SizedBox(width: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
