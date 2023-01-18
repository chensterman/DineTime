import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/menu.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/aboutandstory.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/photogallery.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/dietaryoptions.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/links.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/divider.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/maincardwidgets/logo.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/maincardwidgets/name.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/maincardwidgets/cuisinedetails.dart';
import 'package:dinetime_mobile_mvp/provider/card_provider.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

class TinderCard extends StatefulWidget {
  final User user;
  final bool isFront;
  // final List _menu = []

  const TinderCard({
    Key? key,
    required this.user,
    required this.isFront,
  }) : super(key: key);

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
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

          provider.endPosition();
        },
      );

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
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/food1.png'),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(177, 0, 0, 0),
            Colors.transparent,
            Color.fromARGB(226, 0, 0, 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1],
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
            Logo(
              logopath: widget.user.logoImage,
            ),
            const SizedBox(height: 12),
            const Links(),
            const SizedBox(height: 12),
            Name(name: widget.user.name),
            const SizedBox(height: 5),
            CuisineDetails(
              cuisine: widget.user.cuisine,
              cost: widget.user.cost,
              distance: widget.user.distance,
            ),
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
          AboutandStory(about: widget.user.about),
          const SizedBox(height: 20.0),
          const WidgetDivider(),
          const SizedBox(height: 20.0),
          PhotoGallery(
              photo1: widget.user.photo1,
              photo2: widget.user.photo2,
              photo3: widget.user.photo3),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          DietaryOptions(
            dietary1: widget.user.dietary1,
            dietary2: widget.user.dietary2,
            dietary3: widget.user.dietary3,
          ),
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

  Widget menu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Menu',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.only(left: 5, right: 2),
          width: 360,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Color.fromARGB(95, 158, 158, 158), width: 1),
              borderRadius: BorderRadius.circular(7)),
          child: Expanded(
            child: Column(children: [
              MenuOptions(
                  price: widget.user.menuprice1,
                  image: widget.user.menuph1,
                  itemName: widget.user.menu1,
                  itemDesc: widget.user.menudesc1),
              Divider(color: Color.fromARGB(95, 158, 158, 158), height: 1),
              MenuOptions(
                  price: widget.user.menuprice2,
                  image: widget.user.menuph2,
                  itemName: widget.user.menu2,
                  itemDesc: widget.user.menudesc2),
              Divider(color: Color.fromARGB(95, 158, 158, 158), height: 1),
              MenuOptions(
                  price: widget.user.menuprice3,
                  image: widget.user.menuph3,
                  itemName: widget.user.menu3,
                  itemDesc: widget.user.menudesc3),
              Divider(color: Color.fromARGB(95, 158, 158, 158), height: 1),
              menuButton()
            ]),
          ),
        ),
      ],
    );
  }

  Widget menuButton() {
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
                    height: MediaQuery.of(context).size.height * 0.68,
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
                          height: MediaQuery.of(context).size.height * 0.57,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  MenuOptions(
                                      price: widget.user.menuprice1,
                                      image: widget.user.menuph1,
                                      itemName: widget.user.menu1,
                                      itemDesc: widget.user.menudesc1),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice2,
                                      image: widget.user.menuph2,
                                      itemName: widget.user.menu2,
                                      itemDesc: widget.user.menudesc2),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice3,
                                      image: widget.user.menuph3,
                                      itemName: widget.user.menu3,
                                      itemDesc: widget.user.menudesc3),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice1,
                                      image: widget.user.menuph1,
                                      itemName: widget.user.menu1,
                                      itemDesc: widget.user.menudesc1),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice2,
                                      image: widget.user.menuph2,
                                      itemName: widget.user.menu2,
                                      itemDesc: widget.user.menudesc2),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice3,
                                      image: widget.user.menuph3,
                                      itemName: widget.user.menu3,
                                      itemDesc: widget.user.menudesc3),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice2,
                                      image: widget.user.menuph2,
                                      itemName: widget.user.menu2,
                                      itemDesc: widget.user.menudesc2),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice3,
                                      image: widget.user.menuph3,
                                      itemName: widget.user.menu3,
                                      itemDesc: widget.user.menudesc3),
                                ],
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

  Widget locationsButton() {
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
                      height: MediaQuery.of(context).size.height * 0.68,
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
                          SizedBox(height: 20),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.57,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CupertinoScrollbar(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                    upcomingLocationCard(),
                                    const SizedBox(height: 10.0),
                                  ],
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

  Widget upcomingLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Locations',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        const SizedBox(height: 20.0),
        upcomingLocationCard(),
        const SizedBox(height: 10.0),
        upcomingLocationCard(),
        const SizedBox(height: 10.0),
        upcomingLocationCard(),
        const SizedBox(height: 10.0),
        upcomingLocationCard(),
        const SizedBox(height: 10.0),
        Center(
          child: locationsButton(),
        )
      ],
    );
  }

  Widget upcomingLocationCard() {
    return ListCard(
      height: 60.0,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("DATE"),
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
                        "Location Name",
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              fontSize: 14.0,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Flexible(
                      child: Text(
                        "distance - time",
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

  Widget nextLocation() {
    return Row(
      children: [
        Image.asset(
          'lib/assets/location_white.png',
          width: 18,
          height: 18,
        ),
        SizedBox(width: 5),
        Text(
          widget.user.location,
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
        Icon(
          Icons.access_time_rounded,
          size: 18.0,
          color: Colors.white,
        ),
        SizedBox(width: 5),
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

  Widget nextDate() {
    return Row(
      children: [
        Image.asset(
          'lib/assets/calendar.png',
          width: 15,
          height: 15,
        ),
        const SizedBox(width: 5),
        Text(
          widget.user.date,
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
}
// write another widget of an image