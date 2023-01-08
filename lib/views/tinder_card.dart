import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/provider/card_provider.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class TinderCard extends StatefulWidget {
  final User user;
  final bool isFront;

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
      child: Scrollbar(
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
            logo(),
            const SizedBox(height: 12),
            name(),
            const SizedBox(height: 5),
            cuisineDetails(),
            const SizedBox(height: 20),
            nextLocation(),
            const SizedBox(height: 4),
            nextDate(),
            const SizedBox(height: 12),
            links(),
          ],
        ),
      ),
    );
  }

  Widget additionalDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        aboutAndStory(),
        photoGallery(),
        dietaryOptions(),
        menuItems(),
        upcomingLocations(),
      ]),
    );
  }

  Widget aboutAndStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'About & Story',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        SizedBox(height: 10),
        Text(
          widget.user.about,
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
        SizedBox(height: 10),
        Text(
          'Photo Gallery',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                  image: AssetImage(widget.user.photo1),
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
                  image: AssetImage(widget.user.photo2),
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
                  image: AssetImage(widget.user.photo3),
                  fit: BoxFit.cover,
                  opacity: 0.8),
            ),
          ),
        ]),
      ],
    );
  }

  Widget dietaryOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Dietary Options',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        SizedBox(height: 10),
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
                    widget.user.dietary1,
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
                    widget.user.dietary2,
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
                    widget.user.dietary3,
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

  Widget menuItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Our Menu',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
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
                                    widget.user.menu1,
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
                                    '\$' + widget.user.menuprice1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.copyWith(
                                            fontSize: 12.0,
                                            fontFamily: 'Lato',
                                            color: dineTimeColorScheme.primary),
                                  ),
                                ]),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.user.menudesc1,
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
                                  image: AssetImage(widget.user.menuph1),
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
        ),
      ],
    );
  }

  Widget upcomingLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Upcoming Locations',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5, right: 2),
              width: 332,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Color.fromARGB(95, 158, 158, 158), width: 2),
                  borderRadius: BorderRadius.circular(7)),
            ),
          ],
        ),
      ],
    );
  }

  Widget name() {
    return Text(
      widget.user.name,
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

  Widget logo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: dineTimeColorScheme.primary, width: 4),
      ),
      child: ClipOval(
        child: Image.asset(widget.user.logoImage),
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
            TextSpan(text: widget.user.cuisine),
            const TextSpan(
                text: '   ·   ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: widget.user.cost),
            const TextSpan(
                text: '   ·   ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: widget.user.distance),
          ]),
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
                  shape: const CircleBorder(), elevation: 0.8),
              child: Image.asset(
                'lib/assets/orange_instagram.png',
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
                  shape: const CircleBorder(), elevation: 0.8),
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
                  shape: const CircleBorder(), elevation: 0.8),
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
