import 'dart:math';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/backgroundshadow.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/cuisinedetails.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/dietary.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/logo.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/menu.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/photogallery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/provider/cardprovider.dart';

import 'aboutandstory.dart';
import 'background.dart';
import 'contact.dart';
import 'name.dart';
import 'nextdate.dart';
import 'nextlocation.dart';
import 'nexttime.dart';
import 'stamps.dart';
import 'upcominglocations.dart';

class FoodCard extends StatefulWidget {
  final Customer customer;
  final r.Restaurant restaurant;
  final bool isFront;
  final Services services;
  const FoodCard({
    Key? key,
    required this.customer,
    required this.restaurant,
    required this.isFront,
    required this.services,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isMainDetailsVisible = true;
  double _opacity = 0.0;
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
            // Notifications for Analytics

            if (scrollNotification is ScrollEndNotification) {
              print(_controller.position.pixels);
              if (_controller.position.pixels >= _mainDetailsHeight &&
                  _controller.position.pixels < _additionalDetailsHeight) {
                widget.services.clientAnalytics
                    .trackScreenView('MainDetails', 'FYFPage');
              } else if (_controller.position.pixels >=
                      _additionalDetailsHeight &&
                  _controller.position.pixels < _aboutAndStoryHeight) {
                widget.services.clientAnalytics
                    .trackScreenView('AddDetails', 'FYFPage');
              } else if (_controller.position.pixels >= _aboutAndStoryHeight &&
                  _controller.position.pixels < _photoGalleryHeight) {
                widget.services.clientAnalytics
                    .trackScreenView('AboutAndStory', 'FYFPage');
              } else if (_controller.position.pixels >= _photoGalleryHeight &&
                  _controller.position.pixels < _dietaryOptionsHeight) {
                widget.services.clientAnalytics
                    .trackScreenView('PhotoGallery', 'FYFPage');
              } else if (_controller.position.pixels >= _dietaryOptionsHeight &&
                  _controller.position.pixels < _menuItemsHeight) {
                widget.services.clientAnalytics
                    .trackScreenView('DietOptions', 'FYFPage');
              } else {
                widget.services.clientAnalytics
                    .trackScreenView('UpcomingLocs', 'UpcomingLocs');
              }
            }
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
            controller: _controller,
            child: Scrollbar(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Background(
                        width: width,
                        height: height,
                        restaurantMenu: widget.restaurant.menu,
                        services: widget.services,
                      ),
                      BackgroundShadow(width: width, height: height),
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

  Widget mainDetails(double width, double height) {
    Visibility mainDetails = Visibility(
      visible: _isMainDetailsVisible,
      child: Opacity(
        opacity: 1.0 - _opacity,
        child: Container(
          key: _mainDetailsKey,
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 30.0, bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Logo(
                  restaurantLogoRef: widget.restaurant.restaurantLogoRef,
                  services: widget.services,
                ),
                const SizedBox(height: 18),
                Name(
                  restaurantName: widget.restaurant.restaurantName,
                  color: Theme.of(context).colorScheme.background,
                ),
                CuisineDetails(
                  cuisine: widget.restaurant.cuisine,
                  pricing: widget.restaurant.pricing,
                  customerLocation: widget.customer.geolocation,
                  locations: widget.restaurant.upcomingLocations,
                  color: Theme.of(context).colorScheme.background,
                ),
                const SizedBox(height: 18),
                widget.restaurant.upcomingLocations.isNotEmpty
                    ? NextLocation(
                        locationName:
                            widget.restaurant.upcomingLocations[0].locationName,
                        imagePath: 'lib/assets/location_white.png',
                        color: Theme.of(context).colorScheme.background,
                      )
                    : Container(),
                const SizedBox(height: 7),
                widget.restaurant.upcomingLocations.isNotEmpty
                    ? NextDate(
                        locationDateStart: widget
                            .restaurant.upcomingLocations[0].locationDateStart,
                        imagePath: 'lib/assets/calendar.png',
                        color: Theme.of(context).colorScheme.background,
                      )
                    : Container(),
                const SizedBox(height: 7),
                widget.restaurant.upcomingLocations.isNotEmpty
                    ? NextTime(
                        locationDateStart: widget
                            .restaurant.upcomingLocations[0].locationDateStart,
                        locationDateEnd: widget
                            .restaurant.upcomingLocations[0].locationDateEnd,
                        imagePath: 'lib/assets/clock_white.png',
                        color: Theme.of(context).colorScheme.background,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
    return mainDetails;
  }

  Widget additionalDetails() {
    Padding additionalDetails = Padding(
      padding: const EdgeInsets.only(
          left: 25.0, right: 25.0, top: 15.0, bottom: 15.0),
      child: Column(
        key: _additionalDetailsKey,
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
            customerLocation: widget.customer.geolocation,
            locations: widget.restaurant.upcomingLocations,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(height: 15),
          widget.restaurant.upcomingLocations.isNotEmpty
              ? NextLocation(
                  locationName:
                      widget.restaurant.upcomingLocations[0].locationName,
                  imagePath: 'lib/assets/location_arrow_orange.png',
                  color: Theme.of(context).colorScheme.onBackground,
                )
              : Container(),
          const SizedBox(height: 7),
          widget.restaurant.upcomingLocations.isNotEmpty
              ? NextDate(
                  locationDateStart:
                      widget.restaurant.upcomingLocations[0].locationDateStart,
                  imagePath: 'lib/assets/calendar_orange.png',
                  color: Theme.of(context).colorScheme.onBackground,
                )
              : Container(),
          const SizedBox(height: 7),
          widget.restaurant.upcomingLocations.isNotEmpty
              ? NextTime(
                  locationDateStart:
                      widget.restaurant.upcomingLocations[0].locationDateStart,
                  locationDateEnd:
                      widget.restaurant.upcomingLocations[0].locationDateEnd,
                  imagePath: 'lib/assets/clock_orange.png',
                  color: Theme.of(context).colorScheme.onBackground,
                )
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
          Dietary(menu: widget.restaurant.menu),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          Menu(
            menu: widget.restaurant.menu,
          ),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          UpcomingLocations(
              customerLocation: widget.customer.geolocation,
              popUpLocations: widget.restaurant.upcomingLocations),
        ],
      ),
    );
    return additionalDetails;
  }
}
