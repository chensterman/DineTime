import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class FoodCard extends StatefulWidget {
  final Restaurant restaurant;
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
  final ScrollController _controller = ScrollController();
  final GlobalKey _mainDetailsKey = GlobalKey();
  final GlobalKey _additionalDetailsKey = GlobalKey();
  final GlobalKey _aboutAndStoryKey = GlobalKey();
  final GlobalKey _photoGalleryKey = GlobalKey();
  final GlobalKey _dietaryOptionsKey = GlobalKey();
  final GlobalKey _menuItemsKey = GlobalKey();
  double _mainDetailsHeight = 0;
  double _additionalDetailsHeight = 0;
  double _aboutAndStoryHeight = 0;
  double _photoGalleryHeight = 0;
  double _dietaryOptionsHeight = 0;
  double _menuItemsHeight = 0;
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

  // Widget buildCardHelper()
  Widget buildCard(BuildContext context) {
    // Get size of screen
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.9;
    double height = size.height * 0.7;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: NotificationListener<ScrollEndNotification>(
          child: SingleChildScrollView(
            controller: _controller,
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
          onNotification: (t) {
            if (_controller.position.pixels >= _mainDetailsHeight &&
                _controller.position.pixels < _additionalDetailsHeight) {
              Analytics()
                  .getInstance()
                  .logScreenView(screenClass: 'MainDet', screenName: 'MainDet');
            } else if (_controller.position.pixels >=
                    _additionalDetailsHeight &&
                _controller.position.pixels < _aboutAndStoryHeight) {
              Analytics()
                  .getInstance()
                  .logScreenView(screenClass: 'AddtDet', screenName: 'AddtDet');
            } else if (_controller.position.pixels >= _aboutAndStoryHeight &&
                _controller.position.pixels < _photoGalleryHeight) {
              Analytics().getInstance().logScreenView(
                  screenClass: 'AboutAndStory', screenName: 'AboutAndStory');
            } else if (_controller.position.pixels >= _photoGalleryHeight &&
                _controller.position.pixels < _dietaryOptionsHeight) {
              Analytics().getInstance().logScreenView(
                  screenClass: 'PhotoGal', screenName: 'PhotoGal');
            } else if (_controller.position.pixels >= _dietaryOptionsHeight &&
                _controller.position.pixels < _menuItemsHeight) {
              Analytics().getInstance().logScreenView(
                  screenClass: 'DietOptions', screenName: 'DietOptions');
            } else {
              Analytics().getInstance().logScreenView(
                  screenClass: 'UpcomingLocs', screenName: 'UpcomingLocs');
            }
            return true;
          },
        ));
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
    Container mainDetails = Container(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          key: _mainDetailsKey,
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
    _mainDetailsHeight = _mainDetailsKey.currentContext!.size!.height;
    return mainDetails;
  }

  Widget additionalDetails() {
    Padding additionalDetails = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        key: _additionalDetailsKey,
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
          menuItems(),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          upcomingLocations(),
        ],
      ),
    );
    _additionalDetailsHeight =
        _additionalDetailsKey.currentContext!.size!.height;
    return additionalDetails;
  }

  Widget aboutAndStory() {
    Column aboutAndStory = Column(
      key: _aboutAndStoryKey,
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
    _aboutAndStoryHeight = _aboutAndStoryKey.currentContext!.size!.height;
    return aboutAndStory;
  }

  Widget photoGallery() {
    Column photoGallery = Column(
      key: _photoGalleryKey,
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
    _photoGalleryHeight = _photoGalleryKey.currentContext!.size!.height;
    return photoGallery;
  }

  Widget dietaryOptions() {
    Column dietaryOptions = Column(
      key: _dietaryOptionsKey,
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
    _dietaryOptionsHeight = _dietaryOptionsKey.currentContext!.size!.height;
    return dietaryOptions;
  }

  Widget menuItems() {
    Column menuItems = Column(
      key: _menuItemsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Menu',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(left: 5, right: 2),
          width: 332,
          height: 104,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Color.fromARGB(95, 158, 158, 158), width: 2),
              borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                widget.restaurant.menu[0].itemName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 12.0,
                                      fontFamily: 'Lato',
                                    ),
                              ),
                              SizedBox(width: 30),
                              Text(
                                '\$' +
                                    widget.restaurant.menu[0].itemPrice
                                        .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                        fontSize: 12.0,
                                        fontFamily: 'Lato',
                                        color: dineTimeColorScheme.primary),
                              ),
                            ]),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.restaurant.menu[0].itemDescription!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                    fontSize: 10.0,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.5),
                          image: DecorationImage(
                              image: widget.restaurant.menu[0].itemPhoto!,
                              fit: BoxFit.cover,
                              opacity: 0.8),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
    _menuItemsHeight = _menuItemsKey.currentContext!.size!.height;
    return menuItems;
  }

  Widget upcomingLocations() {
    List<PopUpLocation> popUpLocations = widget.restaurant.upcomingLocations;
    List<Widget> columnChildren = [
      Text(
        'Upcoming Locations',
        style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 20.0,
              fontFamily: 'Lato',
            ),
      ),
    ];
    for (PopUpLocation popUpLocation in popUpLocations) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(upcomingLocationCard(
          popUpLocation.locationDateStart, popUpLocation.name, 2.0));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
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
