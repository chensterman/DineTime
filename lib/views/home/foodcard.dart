import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

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
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : buildCard(context),
      );

  Widget buildFrontCard() => GestureDetector(
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
                children: [
                  buildCard(context),
                  buildStamps(),
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

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = stamp(
          angle: -0.5,
          color: Colors.green,
          text: 'LIKE',
          opacity: opacity,
        );

        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = stamp(
          angle: 0.5,
          color: Colors.red,
          text: 'NOPE',
          opacity: opacity,
        );

        return Positioned(top: 64, right: 50, child: child);
      default:
        return Container();
    }
  }

  Widget stamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context) {
    // Get size of screen
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.9;
    double height = size.height * 0.7;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                mainBackground(width, height),
                mainBackgroundShadow(width, height),
                mainDetails(width, height),
              ],
            ),
            additionalDetails(),
          ],
        ),
      ),
    );
  }

  Widget mainBackground(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.restaurant.menu[0].itemPhoto!,
          fit: BoxFit.cover,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }

  Widget mainBackgroundShadow(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
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
    return Container(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logo(),
            const SizedBox(height: 12),
            links(),
            const SizedBox(height: 12),
            name(),
            const SizedBox(height: 5),
            cuisineDetails(),
            const SizedBox(height: 20),
            nextLocation(),
            const SizedBox(height: 5),
            nextDate(),
            const SizedBox(height: 5),
            nextTime(),
          ],
        ),
      ),
    );
  }

  Widget additionalDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          aboutAndStory(),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          photoGallery(),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          dietaryOptions(),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          menu(),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          upcomingLocations(),
        ],
      ),
    );
  }

  Widget aboutAndStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About & Story',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.restaurant.bio!,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                fontSize: 12.0,
                fontFamily: 'Lato',
              ),
        ),
      ],
    );
  }

  Widget photoGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo Gallery',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                    image: widget.restaurant.gallery[0].image,
                    fit: BoxFit.cover,
                    opacity: 0.8),
              ),
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                    image: widget.restaurant.gallery[0].image,
                    fit: BoxFit.cover,
                    opacity: 0.8),
              ),
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                    image: widget.restaurant.gallery[0].image,
                    fit: BoxFit.cover,
                    opacity: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget dietaryOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary Options',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
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
      columnChildren.add(menuOption(
          menuItem.itemName, menuItem.itemDescription!, menuItem.itemPrice));
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
    columnChildren.add(Center(
      child: menuButton(),
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        const SizedBox(height: 20),
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

  Widget menuOption(String itemName, String itemDesc, num price) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemName,
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 12.0,
                                    fontFamily: 'Lato',
                                  ),
                        ),
                        Text(
                          '\$' + price.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(
                                  fontSize: 12.0,
                                  fontFamily: 'Lato',
                                  color: dineTimeColorScheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      itemDesc,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 8.0,
                            fontFamily: 'Lato',
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Container(
                  height: 60,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.5),
                    image: DecorationImage(
                        image: AssetImage("lib/assets/dinetime-orange.png"),
                        fit: BoxFit.cover,
                        opacity: 0.8),
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
      columnChildren.add(menuOption(
          menuItem.itemName, menuItem.itemDescription!, menuItem.itemPrice));
      const Divider(
        color: Color.fromARGB(95, 158, 158, 158),
        height: 1,
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
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
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
                                    height: 15,
                                    width: 15),
                                const SizedBox(width: 10),
                                Text(
                                  "Go Back",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          fontSize: 15.0,
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
                                      fontSize: 25.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: columnChildren,
                              ),
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
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 250,
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
                    Text(
                      "View full menu",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 10.0,
                          color: dineTimeColorScheme.primary,
                          fontFamily: 'Lato'),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward,
                      color: dineTimeColorScheme.primary,
                      size: 10,
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
              fontSize: 20.0,
              fontFamily: 'Lato',
            ),
      ),
    ];
    num count = 0;
    for (r.PopUpLocation popUpLocation in popUpLocations) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(upcomingLocationCard(
          popUpLocation.locationDateStart, popUpLocation.name, 2.0));
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
      columnChildren.add(upcomingLocationCard(
          popUpLocation.locationDateStart, popUpLocation.name, 2.0));
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
                  child: Padding(
                    padding: EdgeInsets.all(25),
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
                                    height: 15,
                                    width: 15),
                                const SizedBox(width: 10),
                                Text(
                                  "Go Back",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          fontSize: 15.0,
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
                                "Upcoming Locations",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 25.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: columnChildren,
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
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 250,
              height: 22,
              decoration: BoxDecoration(
                color: dineTimeColorScheme.primary.withOpacity(0.2),
                shape: BoxShape.rectangle,
              ),
              child: Center(
                  child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "View all upcoming locations",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 10.0,
                          color: dineTimeColorScheme.primary,
                          fontFamily: 'Lato'),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward,
                      color: dineTimeColorScheme.primary,
                      size: 10,
                    ),
                  ],
                ),
              )),
            ),
          )),
    );
  }

  Widget upcomingLocationCard(
      Timestamp dateStart, String name, double distance) {
    return ListCard(
      height: 60.0,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Text('${dateStart.toDate().month}/${dateStart.toDate().day}'),
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
                    // Text overflow works by wrapping text under Flexible widget
                    Flexible(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Flexible(
                      child: Text(
                        "$distance mi - ${dateStart.toDate().hour}:${dateStart.toDate().minute} ${dateStart.toDate().timeZoneName}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontSize: 12.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      // Display image based on availability of user uploaded image
                      image: AssetImage('lib/assets/instagram.png'),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      // Display image based on availability of user uploaded image
                      image: AssetImage('lib/assets/instagram.png'),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget name() {
    return Text(
      widget.restaurant.restaurantName,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 28.0,
            color: dineTimeColorScheme.background,
            fontFamily: 'Lato',
          ),
    );
  }

  Widget nextLocation() {
    return Row(
      children: [
        Image.asset(
          'lib/assets/location_white.png',
          width: 18,
          height: 18,
        ),
        const SizedBox(width: 5),
        Text(
          widget.restaurant.upcomingLocations[0].name,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12.0,
              color: dineTimeColorScheme.background,
              fontFamily: 'Lato'),
        ),
      ],
    );
  }

  Widget nextTime() {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 18.0,
          color: Colors.white,
        ),
        const SizedBox(width: 5),
        Text(
          "3:00 - 6:00 PM PST",
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12.0,
              color: dineTimeColorScheme.background,
              fontFamily: 'Lato'),
        ),
      ],
    );
  }

  Widget logo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: widget.restaurant.restaurantLogo,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: dineTimeColorScheme.primary, width: 4),
      ),
    );
  }

  Widget cuisineDetails() {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12.0,
              color: dineTimeColorScheme.background,
              fontFamily: 'Lato'),
          children: [
            TextSpan(text: widget.restaurant.cuisine),
            const TextSpan(
                text: '   ·   ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '\$' * widget.restaurant.pricing),
            const TextSpan(
                text: '   ·   ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '2.2 mi'),
          ]),
    );
  }

  Widget nextDate() {
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
        Image.asset(
          'lib/assets/calendar.png',
          width: 15,
          height: 15,
        ),
        const SizedBox(width: 5),
        Text(
          nextDate,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12.0,
              color: dineTimeColorScheme.background,
              fontFamily: 'Lato'),
        ),
        const SizedBox(width: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 80,
            height: 18,
            decoration: BoxDecoration(
              color: dineTimeColorScheme.primary.withOpacity(0.7),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Text(
                "3 days away",
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontSize: 12.0,
                    color: dineTimeColorScheme.background,
                    fontFamily: 'Lato'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget links() {
    return Row(
      children: [
        Link(
          uri: Uri.parse('instagram.com'),
          builder: (context, followLink) => SizedBox(
            width: 52,
            height: 35,
            child: ElevatedButton(
              onPressed: followLink,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 0.8),
              child: Image.asset(
                'lib/assets/instagram_orange.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
        Link(
          uri: Uri.parse('instagram.com'),
          builder: (context, followLink) => SizedBox(
            width: 52,
            height: 35,
            child: ElevatedButton(
              onPressed: followLink,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 0.8),
              child: Image.asset(
                'lib/assets/world2.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        Link(
          uri: Uri.parse('instagram.com'),
          builder: (context, followLink) => SizedBox(
            width: 52,
            height: 35,
            child: ElevatedButton(
              onPressed: followLink,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 0.8),
              child: Image.asset(
                'lib/assets/email.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        const Spacer(),
        Image.asset(
          'lib/assets/link.png',
          width: 20,
          height: 20,
        ),
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
