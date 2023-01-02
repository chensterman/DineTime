import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/mock_data/restaurants_data.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/services.dart';

// Restaurant info display card
class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
  });
  Widget buildLocIcons() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 0.3,
            child: const Image(
              image: AssetImage(
                  '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/Group_53.png'),
            ),
          ),

          Transform.scale(
            scale: 0.3,
            child: const Image(
              image: AssetImage(
                  '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/Group_64.png'),
            ),
          ),
          // SizedBox(width: 10.0),
          Transform.scale(
            scale: 0.3,
            child: const Image(
              image: AssetImage(
                  '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/Group_63.png'),
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    // Get size of screen
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.9;
    double height = size.height * 0.7;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.background,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/restaurant.png'),
                      ),
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 1]),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          Positioned(
                            bottom: 120,
                            left: 30,
                            child: Text(
                              'Mr. West Cafe & Bar',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    fontSize: 20.0,
                                    color: dineTimeColorScheme.background,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                          Positioned(
                            bottom: 150,
                            left: 20,
                            child: Container(
                              width: 150,
                              height: 50,
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.7,
                                    child: const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/Group_53.png'),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/Group_64.png'),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/Group_63.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 80,
                            left: 30,
                            child: Container(
                              width: 200,
                              height: 60,
                              child: Row(
                                children: [
                                  Text(
                                    'American',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                          fontSize: 12.0,
                                          color: dineTimeColorScheme.background,
                                          fontFamily: 'Lato',
                                        ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Text(
                                    '•',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                          fontSize: 18.0,
                                          color: dineTimeColorScheme.background,
                                          fontFamily: 'Lato',
                                        ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Text(
                                    '\$\$\$\$',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                          fontSize: 12.0,
                                          color: dineTimeColorScheme.background,
                                          fontFamily: 'Lato',
                                        ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Text(
                                    '•',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                          fontSize: 18.0,
                                          color: dineTimeColorScheme.background,
                                          fontFamily: 'Lato',
                                        ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Text(
                                    'Dine-In',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                          fontSize: 12.0,
                                          color: dineTimeColorScheme.background,
                                          fontFamily: 'Lato',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 45,
                            left: 30,
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Text(
                                '4.5',
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontSize: 12.0,
                                      color: dineTimeColorScheme.background,
                                      fontFamily: 'Lato',
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 64,
                            left: 30,
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Transform.scale(
                                scale: 0.3,
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/star.png'),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 78,
                            child: Container(
                              width: 130,
                              height: 50,
                              child: Text(
                                '•',
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontSize: 18.0,
                                      color: dineTimeColorScheme.background,
                                      fontFamily: 'Lato',
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 46,
                            left: 95,
                            child: Container(
                              width: 130,
                              height: 50,
                              child: Text(
                                '1000+ Ratings',
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontSize: 12.0,
                                      color: dineTimeColorScheme.background,
                                      fontFamily: 'Lato',
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 580,
                            left: 0,
                            child: Container(
                              width: 85,
                              height: 50,
                              child: Transform.scale(
                                scale: 1.0,
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/reload.png'),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 23,
                            left: 8,
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Transform.scale(
                                scale: 0.3,
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/location_white.png'),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 55,
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Text(
                                '1.2 mi',
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontSize: 12.0,
                                      color: dineTimeColorScheme.background,
                                      fontFamily: 'Lato',
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 23,
                            left: 88,
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Transform.scale(
                                scale: 0.3,
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/time.png'),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 140,
                            child: Container(
                              width: 120,
                              height: 50,
                              child: Text(
                                '9:00 AM - 10:00 PM',
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontSize: 12.0,
                                      color: dineTimeColorScheme.background,
                                      fontFamily: 'Lato',
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            left: 320,
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Transform.scale(
                                scale: 0.4,
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/link.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: height * 0.8,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Positioned(
                          top: 15,
                          left: 13,
                          child: Container(
                            width: 60,
                            height: 50,
                            // color: Colors.black,
                            child: Transform.scale(
                              scale: 0.7,
                              child: const Image(
                                image: AssetImage(
                                    '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/location_orange.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 65,
                          child: Container(
                            width: 60,
                            height: 50,
                            // color: Colors.black,
                            child: Transform.scale(
                              scale: 0.7,
                              child: const Image(
                                image: AssetImage(
                                    '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/call_orange.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 117,
                          child: Container(
                            width: 60,
                            height: 50,
                            // color: Colors.black,
                            child: Transform.scale(
                              scale: 0.7,
                              child: const Image(
                                image: AssetImage(
                                    '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/world_orange.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 70,
                          left: 28,
                          child: Text(
                            'Mr. West Cafe & Bar',
                            textAlign: TextAlign.left,
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      fontSize: 20.0,
                                      fontFamily: 'Lato',
                                    ),
                          ),
                        ),
                        Positioned(
                          top: 75,
                          left: 28,
                          child: Container(
                            width: 200,
                            height: 60,
                            child: Row(
                              children: [
                                Text(
                                  'American',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontSize: 12.0,
                                        color: dineTimeColorScheme.onBackground,
                                        fontFamily: 'Lato',
                                      ),
                                ),
                                SizedBox(width: 12.0),
                                Text(
                                  '•',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontSize: 18.0,
                                        color: dineTimeColorScheme.onBackground,
                                        fontFamily: 'Lato',
                                      ),
                                ),
                                SizedBox(width: 12.0),
                                Text(
                                  '\$\$\$\$',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontSize: 12.0,
                                        color: dineTimeColorScheme.onBackground,
                                        fontFamily: 'Lato',
                                      ),
                                ),
                                SizedBox(width: 12.0),
                                Text(
                                  '•',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontSize: 18.0,
                                        color: dineTimeColorScheme.onBackground,
                                        fontFamily: 'Lato',
                                      ),
                                ),
                                SizedBox(width: 12.0),
                                Text(
                                  'Dine-In',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontSize: 12.0,
                                        color: dineTimeColorScheme.onBackground,
                                        fontFamily: 'Lato',
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 28,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Text(
                              '4.5',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontSize: 12.0,
                                    color: dineTimeColorScheme.onBackground,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 101,
                          left: 30,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Transform.scale(
                              scale: 0.3,
                              child: const Image(
                                image: AssetImage(
                                    '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/star.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 115,
                          left: 78,
                          child: Container(
                            width: 130,
                            height: 50,
                            child: Text(
                              '•',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontSize: 18.0,
                                    color: dineTimeColorScheme.onBackground,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 98,
                          child: Container(
                            width: 130,
                            height: 50,
                            child: Text(
                              '1000+ Ratings',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontSize: 12.0,
                                    color: dineTimeColorScheme.onBackground,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 135,
                          left: 7,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Transform.scale(
                              scale: 0.3,
                              child: const Image(
                                image: AssetImage(
                                    '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/location_arrow_orange.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 153,
                          left: 58,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Text(
                              '1.2 mi',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontSize: 12.0,
                                    color: dineTimeColorScheme.onBackground,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 135,
                          left: 90,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Transform.scale(
                              scale: 0.3,
                              child: const Image(
                                image: AssetImage(
                                    '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/time_orange.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 153,
                          left: 140,
                          child: Container(
                            width: 120,
                            height: 50,
                            child: Text(
                              '9:00 AM - 10:00 PM',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontSize: 12.0,
                                    color: dineTimeColorScheme.onBackground,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 315,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Transform.scale(
                              scale: 0.4,
                              child: const Image(
                                image: AssetImage(
                                    '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/link_orange.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 160,
                          left: 0,
                          child: Container(
                            width: width,
                            height: 50,
                            child: Transform.scale(
                              scale: 1.0,
                              child: const Divider(
                                color: Color(0xFFEAEAEA),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 200,
                          left: 28,
                          child: Container(
                            width: 160,
                            height: 50,
                            child: Text(
                              'Featured Photos',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    fontSize: 16.0,
                                    color: dineTimeColorScheme.onBackground,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 250,
                          left: 45,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Transform.scale(
                              scale: 1.75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/food1.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 250,
                          left: 160,
                          child: Container(
                            width: 60,
                            height: 50,
                            child: Transform.scale(
                              scale: 1.75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/food2.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 250,
                          left: 275,
                          child: SizedBox(
                            width: 60,
                            height: 50,
                            child: Transform.scale(
                              scale: 1.75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: const Image(
                                  image: AssetImage(
                                      '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/food3.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 320,
                          left: 0,
                          child: Container(
                            width: width,
                            height: 50,
                            child: Transform.scale(
                              scale: 1.0,
                              child: const Divider(
                                color: Color(0xFFEAEAEA),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 110,
                          left: 28,
                          child: Container(
                            width: 2000,
                            height: 50,
                            child: Text(
                              'What people are saying',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    fontSize: 16.0,
                                    color: dineTimeColorScheme.onBackground,
                                    fontFamily: 'Lato',
                                  ),
                            ),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Positioned(
                              bottom: 30,
                              left: 28,
                              child: Container(
                                width: 165,
                                height: 95,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFEAEAEA)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(7.0)),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 60,
                              left: 42,
                              child: Container(
                                width: 2000,
                                height: 50,
                                child: Text(
                                  'Jeff Jordan',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(
                                        fontSize: 10.0,
                                        color: dineTimeColorScheme.onBackground,
                                        fontFamily: 'Lato',
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 63,
                              left: 105,
                              child: Container(
                                width: 130,
                                height: 50,
                                child: Text('•',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ),
                            ),
                            Positioned(
                              bottom: 58,
                              left: 118,
                              child: Container(
                                width: 130,
                                height: 50,
                                child: Text(
                                  '10/14/2022',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                        fontSize: 8.0,
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 85,
                              left: 40,
                              child: Container(
                                width: 90,
                                height: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/star.png'),
                                    ),
                                    const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/star.png'),
                                    ),
                                    const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/star.png'),
                                    ),
                                    const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/star.png'),
                                    ),
                                    const Image(
                                      image: AssetImage(
                                          '/Users/jpalamand/DineTime/dinetime_mobile_mvp/lib/assets/star.png'),
                                    ),
                                    Text(
                                      '5.0',
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(
                                            fontSize: 8.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Positioned(
                              bottom: 30,
                              left: 200,
                              child: Container(
                                width: 170,
                                height: 95,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFEAEAEA)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(7.0)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
