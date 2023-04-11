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
import 'datedropdown.dart';

// Cards that display list items in saved
class EditUpcomingLocations extends StatefulWidget {
  const EditUpcomingLocations({Key? key}) : super(key: key);

  @override
  _EditUpcomingLocationsState createState() => _EditUpcomingLocationsState();
}

class _EditUpcomingLocationsState extends State<EditUpcomingLocations> {
  final double _cardHeight = 75.0;

  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();

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
                                      "Edit Location",
                                      style: dineTimeTypography.headlineLarge,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tell customers where you will be",
                                      style: dineTimeTypography.bodyLarge
                                          ?.copyWith(
                                        color: dineTimeColorScheme.primary,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 60.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Enter a Date",
                                      style: dineTimeTypography.bodySmall,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropdownExample(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Enter an Address",
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
                                    hintText:
                                        '1050 N 34th St, Seattle, WA 98103',
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
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start Time",
                                          style: dineTimeTypography.bodySmall,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextField(
                                            controller: textController2,
                                            maxLength: 20,
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 14,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: '9:00 AM PST',
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
                                          "End Time",
                                          style: dineTimeTypography.bodySmall,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextField(
                                            controller: textController3,
                                            maxLength: 20,
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 14,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: '7:00 PM PST',
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
                                  ],
                                ),
                                SizedBox(height: 60.0),
                                Center(
                                  child: FractionallySizedBox(
                                    widthFactor: 0.9,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: dineTimeColorScheme.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        minimumSize: Size(45, 45),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Done',
                                              style: dineTimeTypography
                                                  .headlineSmall
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        minimumSize: Size(45, 45),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Delete Location',
                                              style: dineTimeTypography
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      fontSize: 16.0,
                                                      color: dineTimeColorScheme
                                                          .primary),
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
                SizedBox(width: 2.0),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 12.0,
                  ),
                  child: Text("11/22",
                      style: dineTimeTypography.headlineSmall?.copyWith(
                          color: dineTimeColorScheme.primary, fontSize: 18.0)),
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
                              'Seattle Fremont Brewery',
                              style: dineTimeTypography.headlineSmall
                                  ?.copyWith(fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 2),
                          Flexible(
                            child: Text(
                              "1.3 mi  ·  3:00 PM - 6:00 PM PST",
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
