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

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : buildCard(),
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
                  buildCard(),
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

  Widget buildCard() => buildCardShadow(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: Offset(0, 10),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(widget.user.urlImage),
                //widget.user.urlImage),
                fit: BoxFit.cover,
                alignment: Alignment(-0.3, 0),
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
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
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  // buildDietaryOpt(),
                  // buildMenu(),
                  // buildUpcomingLoc()
                  // Food Card 2
                  // buildSocials(),
                  // SizedBox(height: 15),
                  // buildNameLower(),
                  // SizedBox(height: 5),
                  // buildCuisineDetailsLower(),
                  // SizedBox(height: 20),
                  // buildLocationLower(),
                  // SizedBox(height: 14),
                  // buildDateLower(),
                  // SizedBox(height: 25),

                  // buildAboutStory(),
                  // buildPhotoGallery(),

                  // Main food card
                  buildRefresh(),
                  Spacer(),
                  buildLogo(),
                  const SizedBox(height: 12),
                  buildName(),
                  const SizedBox(height: 5),
                  buildCuisineDetails(),
                  const SizedBox(height: 20),
                  buildLocation(),
                  const SizedBox(height: 4),
                  buildDate(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildCardShadow({required Widget child}) => ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.white12,
              ),
            ],
          ),
          child: child,
        ),
      );

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
          angle: -0.5,
          color: Colors.green,
          text: 'LIKE',
          opacity: opacity,
        );

        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = buildStamp(
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

  Widget buildStamp({
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

  Widget buildName() => Row(
        children: [
          Text(
            widget.user.name,
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  fontSize: 28.0,
                  color: dineTimeColorScheme.background,
                  fontFamily: 'Lato',
                ),
          ),
        ],
      );

  Widget buildNameLower() => Row(
        children: [
          Text(
            widget.user.name,
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  fontSize: 28.0,
                  color: Colors.black,
                  fontFamily: 'Lato',
                ),
          ),
        ],
      );

  Widget buildLocation() => Row(
        children: [
          Image.asset(
            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/location_white.png',
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

  Widget buildLocationLower() => Row(
        children: [
          Image.asset(
            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/location_arrow_orange.png',
            width: 18,
            height: 18,
          ),
          SizedBox(width: 5),
          Text(
            widget.user.location,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontSize: 12.0, color: Colors.black, fontFamily: 'Lato'),
          ),
          Spacer(),
          Image.asset(
            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/time_orange.png',
            width: 18,
            height: 18,
          ),
          SizedBox(width: 5),
          Text(
            widget.user.time,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontSize: 12.0, color: Colors.black, fontFamily: 'Lato'),
          ),
        ],
      );

  Widget buildLogo() => Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: dineTimeColorScheme.primary, width: 4),
            ),
            child: ClipOval(
              child: Image.asset(widget.user.logoImage),
            ),
          ),
        ],
      );

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
                  '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/reload.png',
                  width: 200,
                  height: 50,
                ),
              )),
        ],
      );

  Widget buildCuisineDetails() => Row(
        children: [
          RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontSize: 12.0,
                    color: dineTimeColorScheme.background,
                    fontFamily: 'Lato'),
                children: [
                  TextSpan(text: widget.user.cuisine),
                  const TextSpan(
                      text: '   ·   ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.user.cost),
                  const TextSpan(
                      text: '   ·   ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.user.distance),
                ]),
          ),
        ],
      );

  Widget buildCuisineDetailsLower() => Row(
        children: [
          RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontSize: 12.0, color: Colors.black, fontFamily: 'Lato'),
                children: [
                  TextSpan(text: widget.user.cuisine),
                  const TextSpan(
                      text: '   ·   ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.user.cost),
                  const TextSpan(
                      text: '   ·   ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.user.distance),
                ]),
          ),
        ],
      );

  Widget buildDate() => Row(
        children: [
          Image.asset(
            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/calendar.png',
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
          Spacer(),
          Image.asset(
            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/link.png',
            width: 20,
            height: 20,
          ),
        ],
      );
  Widget buildDateLower() => Row(
        children: [
          Image.asset(
            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/calendar_orange.png',
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 7),
          Text(
            widget.user.date,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontSize: 12.0, color: Colors.black, fontFamily: 'Lato'),
          ),
        ],
      );
  Widget buildSocials() => Row(
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
                  '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/orange_instagram.png',
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
                  '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/world2.png',
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
                  '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/email.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          Spacer(),
          Image.asset(
            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/link_orange.png',
            width: 20,
            height: 20,
          ),
        ],
      );
  Widget buildAboutStory() => Row(
        children: [
          Container(
            width: 332, //change
            height: 140, //change
            padding: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color.fromARGB(39, 158, 158, 158)),
                bottom: BorderSide(
                  color: Color.fromARGB(39, 158, 158, 158),
                ),
              ),
            ),
            child: Column(
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
                Flexible(
                  child: Text(
                    widget.user.about,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 12.0,
                          fontFamily: 'Lato',
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  Widget buildPhotoGallery() => Row(
        children: [
          Container(
            width: 332, //change
            height: 190, //change
            padding: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color.fromARGB(39, 158, 158, 158)),
                bottom: BorderSide(
                  color: Color.fromARGB(39, 158, 158, 158),
                ),
              ),
            ),
            child: Column(
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
            ),
          ),
        ],
      );
  Widget buildDietaryOpt() => Row(
        children: [
          Container(
            width: 332, //change
            height: 110, //change
            padding: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color.fromARGB(39, 158, 158, 158)),
                bottom: BorderSide(
                  color: Color.fromARGB(39, 158, 158, 158),
                ),
              ),
            ),
            child: Column(
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
                              color: Color.fromARGB(95, 158, 158, 158),
                              width: 2),
                          borderRadius: BorderRadius.circular(7)),
                      child: Row(
                        children: [
                          Image.asset(
                            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/vegan.png',
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.user.dietary1,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
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
                              color: Color.fromARGB(95, 158, 158, 158),
                              width: 2),
                          borderRadius: BorderRadius.circular(7)),
                      child: Row(
                        children: [
                          Image.asset(
                            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/nut_free.png',
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.user.dietary2,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
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
                              color: Color.fromARGB(95, 158, 158, 158),
                              width: 2),
                          borderRadius: BorderRadius.circular(7)),
                      child: Row(
                        children: [
                          Image.asset(
                            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/vegetarian.png',
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.user.dietary3,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
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
            ),
          ),
        ],
      );
  Widget buildMenu() => Row(
        children: [
          Container(
            width: 332, //change
            height: 200, //change
            padding: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color.fromARGB(39, 158, 158, 158)),
                bottom: BorderSide(
                  color: Color.fromARGB(39, 158, 158, 158),
                ),
              ),
            ),
            child: Column(
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
                              color: Color.fromARGB(95, 158, 158, 158),
                              width: 2),
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    color: dineTimeColorScheme
                                                        .primary),
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
                                          image:
                                              AssetImage(widget.user.menuph1),
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
            ),
          ),
        ],
      );
  Widget buildUpcomingLoc() => Row(
        children: [
          Container(
            width: 332, //change
            height: 200, //change
            padding: EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color.fromARGB(39, 158, 158, 158)),
                bottom: BorderSide(
                  color: Color.fromARGB(39, 158, 158, 158),
                ),
              ),
            ),
            child: Column(
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
                              color: Color.fromARGB(95, 158, 158, 158),
                              width: 2),
                          borderRadius: BorderRadius.circular(7)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
