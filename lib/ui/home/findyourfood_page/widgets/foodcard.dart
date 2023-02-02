import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:dinetime_mobile_mvp/theme/components/photocarousel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:url_launcher/url_launcher.dart';

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
  }

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = stamp(
          color: Colors.green,
          text: 'lib/assets/like_logo.png',
          opacity: opacity,
        );

        return Positioned(top: 290, left: 10, child: child);
      case CardStatus.dislike:
        final child = stamp(
          color: Colors.red,
          text: 'lib/assets/dislike_logo.png',
          opacity: opacity,
        );

        return Positioned(top: 290, right: 10, child: child);
      default:
        return Container();
    }
  }

  Widget stamp({
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
        opacity: opacity, child: Image.asset(text, height: 70, width: 70));
  }

  Widget buildCard(BuildContext context) {
    // Get size of screen
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.9;
    double height = size.height * 0.75;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface, width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: Center(
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
      ),
    );
  }

  Widget mainBackground(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.restaurant.menu.isEmpty
              ? const AssetImage("lib/assets/dinetime-orange.png")
              : widget.restaurant.menu[0].itemPhoto!,
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logo(),
            const SizedBox(height: 12),
            name(),
            const SizedBox(height: 5),
            cuisineDetails(),
            const SizedBox(height: 20),
            widget.restaurant.upcomingLocations.isNotEmpty
                ? nextLocation()
                : Container(),
            const SizedBox(height: 5),
            widget.restaurant.upcomingLocations.isNotEmpty
                ? nextDate()
                : Container(),
            const SizedBox(height: 5),
            widget.restaurant.upcomingLocations.isNotEmpty
                ? nextTime()
                : Container(),
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
        Row(
          children: [
            Text(
              'About & Story',
              style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontSize: 20.0,
                    fontFamily: 'Lato',
                  ),
            ),
            widget.restaurant.instagramHandle != null
                ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: () => launchUrl(Uri.parse(
                          'https://www.instagram.com/${widget.restaurant.instagramHandle!}')),
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Color.fromARGB(255, 224, 224, 224),
                                  spreadRadius: 5)
                            ]),
                        child: const CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage('lib/assets/instagram.png'),
                        ),
                      ),
                    ),
                  )
                : Container(),
            widget.restaurant.website != null
                ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: () => launchUrl(
                          Uri.parse('https://${widget.restaurant.website!}')),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage('lib/assets/website.png'),
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 7),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Color.fromARGB(255, 231, 231, 231),
                                    spreadRadius: 5)
                              ]),
                          child: const CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('lib/assets/website.png'),
                          ),
                        ),
                      ),
                    ))
                : Container(),
          ],
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
    List<r.GalleryImage> gallery = widget.restaurant.gallery;
    List<Widget> galleryChildren = [];
    num count = 0;
    for (r.GalleryImage galleryImage in gallery) {
      galleryChildren.add(
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.5),
            image: DecorationImage(
                image: galleryImage.image, fit: BoxFit.cover, opacity: 0.8),
          ),
        ),
      );
      galleryChildren.add(SizedBox(width: 25));
      count += 1;
      if (count == 3) {
        break;
      }
    }
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
        const SizedBox(height: 20.0),
        InkWell(
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
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
                          const SizedBox(height: 40),
                          Column(
                            children: [
                              PhotoCarousel(
                                images: gallery.map((e) => e.image).toList(),
                                descriptions: gallery
                                    .map((e) => e.imageDescription)
                                    .toList(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: galleryChildren,
          ),
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
      columnChildren.add(menuOption(menuItem.itemName,
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

  Widget menuOption(String itemName, String itemDesc, num price,
      ImageProvider<Object>? itemImage) {
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
                        image: itemImage ??
                            const AssetImage("lib/assets/dinetime-orange.png"),
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
      columnChildren.add(menuOption(menuItem.itemName,
          menuItem.itemDescription!, menuItem.itemPrice, menuItem.itemPhoto));
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
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
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
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
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
            child:
                Text('${dateStart.toDate().month}/${dateStart.toDate().day}'),
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
                            color: Theme.of(context).colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Flexible(
                      child: Text(
                        "$distance mi - $hour:$minute $period $timeZoneName",
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
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: () => launchUrl(Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=${address}')),
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    // Display image based on availability of user uploaded image
                    fit: BoxFit.fill,
                    image: AssetImage('lib/assets/location_grey.png'),
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
          width: 15,
          height: 15,
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
    r.PopUpLocation nextPopUpLocation = widget.restaurant.upcomingLocations[0];
    Timestamp dateStart = nextPopUpLocation.locationDateStart;
    String period = dateStart.toDate().hour > 12 ? "PM" : "AM";
    num hour = dateStart.toDate().hour % 12;
    num minute = dateStart.toDate().minute;
    String timeZoneName = dateStart.toDate().timeZoneName;
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 15.0,
          color: Colors.white,
        ),
        const SizedBox(width: 5),
        Text(
          "$hour:$minute $period $timeZoneName",
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
