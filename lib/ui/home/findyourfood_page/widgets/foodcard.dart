import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:dinetime_mobile_mvp/ui/home/findyourfood_page/widgets/cuisinedetails.dart';
import 'package:dinetime_mobile_mvp/ui/home/findyourfood_page/widgets/menu.dart';
import 'package:dinetime_mobile_mvp/ui/home/findyourfood_page/widgets/photogallery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aboutandstory.dart';
import 'contact.dart';
import 'name.dart';
import 'stamps.dart';

class FoodCard extends StatefulWidget {
  final r.Restaurant restaurant;
  final bool isFront;

  const FoodCard({
    Key? key,
    required this.restaurant,
    required this.isFront,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isMainDetailsVisible = true;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.isFront) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final size = MediaQuery.of(context).size;

        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.setScreenSize(size);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFront ? buildFrontCard() : buildCard(context);
  }

  Widget buildFrontCard() {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: Stack(
              alignment: Alignment.center,
              children: [
                buildCard(context),
                const Stamps(),
              ],
            ),
          );
        },
      ),
      onPanStart: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.startPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.updatePosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.endPosition(widget.restaurant.restaurantId);
      },
    );
  }

  Widget buildCard(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.9;
    double height = size.height * 0.77;
    double scrollLimit = MediaQuery.of(context).size.height * 0.12;
    double opacitydelta = 1.0 / scrollLimit;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels >= scrollLimit) {
              setState(() {
                _isMainDetailsVisible = false;
              });
            } else {
              setState(() {
                _isMainDetailsVisible = true;
                if (scrollNotification.metrics.pixels <= 0) {
                  _opacity = 0.0;
                } else {
                  _opacity = scrollNotification.metrics.pixels * opacitydelta;
                }
              });
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Scrollbar(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      mainBackground(width, height),
                      mainBackgroundShadow(width, height),
                      mainDetails(width, height)
                    ],
                  ),
                  additionalDetails(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainBackground(double width, double height) {
    return Container(
      width: width,
      height: height - 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.restaurant.menu.isEmpty
              ? const AssetImage("lib/assets/dinetime-orange.png")
              : widget.restaurant.menu[0].itemPhoto!,
          fit: BoxFit.cover,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget mainBackgroundShadow(double width, double height) {
    return Container(
      width: width,
      height: height - 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          colors: [
            Colors.transparent,
            Color.fromARGB(255, 0, 0, 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 1],
        ),
      ),
    );
  }

  Widget mainDetails(double width, double height) {
    return Visibility(
      visible: _isMainDetailsVisible,
      child: Opacity(
        opacity: 1.0 - _opacity,
        child: Container(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 30.0, bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                logo(),
                const SizedBox(height: 18),
                Name(
                  restaurantName: widget.restaurant.restaurantName,
                  color: Theme.of(context).colorScheme.background,
                ),
                CuisineDetails(
                  cuisine: widget.restaurant.cuisine,
                  pricing: widget.restaurant.pricing,
                  color: Theme.of(context).colorScheme.background,
                ),
                const SizedBox(height: 18),
                widget.restaurant.upcomingLocations.isNotEmpty
                    ? nextLocation(dineTimeColorScheme.background,
                        'lib/assets/location_white.png')
                    : Container(),
                const SizedBox(height: 7),
                widget.restaurant.upcomingLocations.isNotEmpty
                    ? nextDate(dineTimeColorScheme.background,
                        'lib/assets/calendar.png')
                    : Container(),
                const SizedBox(height: 7),
                widget.restaurant.upcomingLocations.isNotEmpty
                    ? nextTime(dineTimeColorScheme.background,
                        'lib/assets/clock_white.png')
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget additionalDetails() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 25.0, right: 25.0, top: 15.0, bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Contact(
            instagramHandle: widget.restaurant.instagramHandle,
            website: widget.restaurant.website,
            email: widget.restaurant.email,
          ),
          const SizedBox(height: 5),
          Name(
            restaurantName: widget.restaurant.restaurantName,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          CuisineDetails(
            cuisine: widget.restaurant.cuisine,
            pricing: widget.restaurant.pricing,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(height: 15),
          widget.restaurant.upcomingLocations.isNotEmpty
              ? bottomNextLocation(dineTimeColorScheme.onBackground,
                  'lib/assets/location_arrow_orange.png')
              : Container(),
          const SizedBox(height: 7),
          widget.restaurant.upcomingLocations.isNotEmpty
              ? bottomNextDate(dineTimeColorScheme.onBackground,
                  'lib/assets/calendar_orange.png')
              : Container(),
          const SizedBox(height: 7),
          widget.restaurant.upcomingLocations.isNotEmpty
              ? bottomNextTime(dineTimeColorScheme.onBackground,
                  'lib/assets/clock_orange.png')
              : Container(),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          AboutAndStory(restaurantBio: widget.restaurant.bio),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          PhotoGallery(gallery: widget.restaurant.gallery),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          dietaryOptions(),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          Menu(menu: widget.restaurant.menu),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          upcomingLocations(),
        ],
      ),
    );
  }

  Widget dietaryOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary Options',
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.only(left: 5, right: 2),
              width: 85,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Color.fromARGB(95, 158, 158, 158), width: 2),
                  borderRadius: BorderRadius.circular(7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/vegan.png',
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Vegan',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Lato'),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 2),
              width: 95,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Color.fromARGB(95, 158, 158, 158), width: 2),
                  borderRadius: BorderRadius.circular(7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/nut_free.png',
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Nut Free',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Lato'),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 2),
              width: 110,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Color.fromARGB(95, 158, 158, 158), width: 2),
                  borderRadius: BorderRadius.circular(7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/vegetarian.png',
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Vegatarian',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Lato'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget menu() {
    List<r.MenuItem> menu = widget.restaurant.menu;
    List<Widget> columnChildren = [];
    num count = 0;
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(menuOption(12.0, menuItem.itemName,
          menuItem.itemDescription!, menuItem.itemPrice, menuItem.itemPhoto));
      columnChildren.add(
        const Divider(
          color: Color.fromARGB(95, 158, 158, 158),
          height: 1,
        ),
      );
      count += 1;
      if (count == 3) {
        break;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Our Menu',
              style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            menuButton(),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          ),
        ),
      ],
    );
  }

  Widget menuOption(double padding, String itemName, String itemDesc, num price,
      ImageProvider<Object>? itemImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$' + price.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(
                                  fontSize: 14.0,
                                  color: dineTimeColorScheme.primary,
                                  fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          'lib/assets/vegan.png',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          'lib/assets/nut_free.png',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          'lib/assets/vegetarian.png',
                          width: 15,
                          height: 15,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      child: Text(
                        itemDesc,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontSize: 10.0,
                              fontFamily: 'Lato',
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.5),
                      image: DecorationImage(
                          image: itemImage ??
                              const AssetImage(
                                  "lib/assets/dinetime-orange.png"),
                          fit: BoxFit.cover,
                          opacity: 0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget menuButton() {
    List<r.MenuItem> menu = widget.restaurant.menu;
    List<Widget> columnChildren = [];
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(menuOption(0, menuItem.itemName,
          menuItem.itemDescription!, menuItem.itemPrice, menuItem.itemPhoto));
      columnChildren.add(
        const SizedBox(height: 12.0),
      );
      columnChildren.add(
        const Divider(
          color: Color.fromARGB(95, 158, 158, 158),
          height: 1,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                const Image(
                                    image:
                                        AssetImage('lib/assets/back_arrow.png'),
                                    height: 12,
                                    width: 12),
                                const SizedBox(width: 10),
                                Text(
                                  "Go Back",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          fontSize: 12.0,
                                          fontFamily: 'Lato',
                                          color: dineTimeColorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Text(
                                "Menu",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: columnChildren,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 135,
            height: 25,
            decoration: BoxDecoration(
              color: dineTimeColorScheme.primary.withOpacity(0.2),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        image: AssetImage('lib/assets/view_menu.png'),
                        height: 10,
                        width: 10),
                    const SizedBox(width: 5),
                    Text(
                      "View full menu",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 10.0,
                          color: dineTimeColorScheme.primary,
                          fontFamily: 'Lato'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget upcomingLocations() {
    List<r.PopUpLocation> popUpLocations = widget.restaurant.upcomingLocations;
    List<Widget> columnChildren = [
      Text(
        'Upcoming Locations',
        style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
      ),
    ];
    num count = 0;
    for (r.PopUpLocation popUpLocation in popUpLocations) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(upcomingLocationCard(popUpLocation.locationDateStart,
          popUpLocation.name, 2.0, popUpLocation.locationAddress));
      count += 1;
      if (count == 3) {
        break;
      }
    }
    columnChildren.add(Center(
      child: locationsButton(),
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }

  Widget locationsButton() {
    List<r.PopUpLocation> popUpLocations = widget.restaurant.upcomingLocations;
    List<Widget> columnChildren = [];
    for (r.PopUpLocation popUpLocation in popUpLocations) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(upcomingLocationCard(popUpLocation.locationDateStart,
          popUpLocation.name, 2.0, popUpLocation.locationAddress));
    }
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  const Image(
                                      image: AssetImage(
                                          'lib/assets/back_arrow.png'),
                                      height: 12,
                                      width: 12),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Go Back",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            fontSize: 12.0,
                                            fontFamily: 'Lato',
                                            color: dineTimeColorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Text(
                                  'Upcoming Locations',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: columnChildren,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 190,
              height: 26,
              decoration: BoxDecoration(
                color: dineTimeColorScheme.primary.withOpacity(0.2),
                shape: BoxShape.rectangle,
              ),
              child: Center(
                  child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        image:
                            AssetImage('lib/assets/location_arrow_orange.png'),
                        height: 15,
                        width: 15),
                    const SizedBox(width: 7),
                    Text(
                      "View all upcoming locations",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 10.0,
                          color: dineTimeColorScheme.primary,
                          fontFamily: 'Lato'),
                    ),
                  ],
                ),
              )),
            ),
          )),
    );
  }

  Widget upcomingLocationCard(
      Timestamp dateStart, String name, double distance, String address) {
    String period = dateStart.toDate().hour > 12 ? "PM" : "AM";
    num hour = dateStart.toDate().hour % 12;
    num minute = dateStart.toDate().minute;
    String timeZoneName = dateStart.toDate().timeZoneName;
    return ListCard(
      height: 50.0,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('${dateStart.toDate().month}/${dateStart.toDate().day}',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text overflow works by wrapping text under Flexible widget
                    Flexible(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    Flexible(
                      child: Text(
                        "$distance mi - $hour:$minute $period $timeZoneName",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontSize: 10.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: () => launchUrl(Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=${address}')),
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    // Display image based on availability of user uploaded image
                    fit: BoxFit.fill,
                    image: AssetImage('lib/assets/location_arrow_grey.png'),
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          )
        ],
      ),
    );
  }

  Widget nextLocation(Color color, String imagePath) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 13,
          height: 13,
        ),
        const SizedBox(width: 10.5),
        Text(
          widget.restaurant.upcomingLocations[0].name,
          style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 12.0,
              color: color,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget bottomNextLocation(Color color, String imagePath) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 15,
          height: 15,
        ),
        const SizedBox(width: 10.5),
        Text(
          widget.restaurant.upcomingLocations[0].name,
          style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 12.0,
              color: color,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget nextTime(Color textColor, String imagePath) {
    r.PopUpLocation nextPopUpLocation = widget.restaurant.upcomingLocations[0];
    Timestamp dateStart = nextPopUpLocation.locationDateStart;
    String period = dateStart.toDate().hour > 12 ? "PM" : "AM";
    num hour = dateStart.toDate().hour % 12;
    num minute = dateStart.toDate().minute;
    String timeZoneName = dateStart.toDate().timeZoneName;
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 13,
          height: 13,
        ),
        const SizedBox(width: 10.5),
        Text(
          "$hour:$minute $period $timeZoneName",
          style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 12.0,
              color: textColor,
              fontFamily: 'Lato',
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget bottomNextTime(Color textColor, String imagePath) {
    r.PopUpLocation nextPopUpLocation = widget.restaurant.upcomingLocations[0];
    Timestamp dateStart = nextPopUpLocation.locationDateStart;
    String period = dateStart.toDate().hour > 12 ? "PM" : "AM";
    num hour = dateStart.toDate().hour % 12;
    num minute = dateStart.toDate().minute;
    String timeZoneName = dateStart.toDate().timeZoneName;
    return Row(
      children: [
        const SizedBox(width: 1.0),
        Image.asset(
          imagePath,
          width: 13,
          height: 13,
        ),
        const SizedBox(width: 10.5),
        Text(
          "$hour:$minute $period $timeZoneName",
          style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 12.0,
              color: textColor,
              fontFamily: 'Lato',
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget logo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: widget.restaurant.restaurantLogo,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: dineTimeColorScheme.primary, width: 3),
      ),
    );
  }

  Widget cuisineDetails(Color color) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(fontSize: 12.0, color: color, fontFamily: 'Lato'),
          children: [
            TextSpan(text: widget.restaurant.cuisine),
            const TextSpan(
                text: '   ·   ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
            TextSpan(text: '\$' * widget.restaurant.pricing),
            const TextSpan(
                text: '   ·   ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
            TextSpan(text: '2.2 mi'),
          ]),
    );
  }

  Widget nextDate(Color color, String imagePath) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String nextDate =
        '${months[widget.restaurant.upcomingLocations[0].locationDateStart.toDate().month - 1]} ${widget.restaurant.upcomingLocations[0].locationDateStart.toDate().day}, ${widget.restaurant.upcomingLocations[0].locationDateStart.toDate().year}';
    String daysAway =
        '${DateTime.now().difference(widget.restaurant.upcomingLocations[0].locationDateStart.toDate()).inDays} days away';
    return Row(
      children: [
        const SizedBox(width: 0.5),
        Image.asset(
          imagePath,
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 10.5),
        Text(
          nextDate,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12.0, color: color, fontWeight: FontWeight.normal),
        ),
        const SizedBox(width: 13),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 60,
            height: 15,
            decoration: BoxDecoration(
              color: dineTimeColorScheme.primary.withOpacity(0.7),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Text(
                daysAway,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontSize: 8.0,
                    color: dineTimeColorScheme.background,
                    fontFamily: 'Lato'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomNextDate(Color color, String imagePath) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String nextDate =
        '${months[widget.restaurant.upcomingLocations[0].locationDateStart.toDate().month - 1]} ${widget.restaurant.upcomingLocations[0].locationDateStart.toDate().day}, ${widget.restaurant.upcomingLocations[0].locationDateStart.toDate().year}';
    return Row(
      children: [
        const SizedBox(width: 1.5),
        Image.asset(
          imagePath,
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 10.5),
        Text(
          nextDate,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12.0, color: color, fontWeight: FontWeight.normal),
        ),
        const SizedBox(width: 13),
      ],
    );
  }

  Widget buildRefresh() => Row(
        children: [
          Container(
              width: 50,
              height: 50,
              child: InkWell(
                onTap: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);

                  provider.resetUsers();
                },
                child: Image.asset(
                  'lib/assets/reload.png',
                  width: 200,
                  height: 50,
                ),
              )),
        ],
      );
}
