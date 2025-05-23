import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import '../blocs/preorderbag/preorderbag_bloc.dart';
import 'preorders/preorderbutton.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../provider/cardprovider.dart';

import 'content/backgroundshadow.dart';
import 'content/cuisinedetails.dart';
import 'content/dietary.dart';
import 'content/logo.dart';
import 'content/menu.dart';
import 'content/photogallery.dart';
import 'content/aboutandstory.dart';
import 'content/background.dart';
import 'content/contact.dart';
import 'content/name.dart';
import 'content/nextlocation.dart';
import 'content/stamps.dart';
import 'content/upcominglocations.dart';

class FoodCard extends StatefulWidget {
  final Customer customer;
  final r.Restaurant restaurant;
  final bool isFront;
  final Services services;
  final String? origin;
  const FoodCard({
    Key? key,
    required this.customer,
    required this.restaurant,
    required this.isFront,
    required this.services,
    this.origin,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isMainDetailsVisible = true;
  bool _isTopPreorderButtonVisible = true;
  bool _isBottomPreorderButtonVisible = false;
  double _opacity = 0.0;
  final ScrollController _controller = ScrollController();
  final GlobalKey _mainDetailsKey = GlobalKey();
  final GlobalKey _aboutAndStoryKey = GlobalKey();
  final GlobalKey _photoGalleryKey = GlobalKey();
  final GlobalKey _dietaryOptionsKey = GlobalKey();
  final GlobalKey _menuItemsKey = GlobalKey();
  final GlobalKey _upcomingLocationsKey = GlobalKey();
  double _mainDetailsHeight = 0;
  double _aboutAndStoryHeight = 0;
  double _photoGalleryHeight = 0;
  double _dietaryOptionsHeight = 0;
  double _menuItemsHeight = 0;
  double _upcomingLocationsHeight = 0;
  double _opacityPreorder = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.isFront) {
      WidgetsBinding.instance.addPostFrameCallback(_getHeights);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final size = MediaQuery.of(context).size;

        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.setScreenSize(size);
      });
    }
  }

  _getHeights(_) {
    _mainDetailsHeight = _mainDetailsKey.currentContext!.size!.height;
    _aboutAndStoryHeight = _aboutAndStoryKey.currentContext!.size!.height + 40;
    _photoGalleryHeight = _aboutAndStoryHeight +
        _photoGalleryKey.currentContext!.size!.height +
        40;
    _dietaryOptionsHeight = _photoGalleryHeight +
        _dietaryOptionsKey.currentContext!.size!.height +
        40;
    _menuItemsHeight =
        _dietaryOptionsHeight + _menuItemsKey.currentContext!.size!.height + 40;
    _upcomingLocationsHeight =
        _upcomingLocationsKey.currentContext!.size!.height;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double foodCardWidth = size.width * 0.98;
    double foodCardHeight = size.height * 0.77;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PreorderBagBloc(
            clientDB: widget.services.clientDB,
            preorderBag: r.PreorderBag(
              preorderId: "INITIAL",
              customerEmail: "initial",
              restaurant: widget.restaurant,
              location: widget.restaurant.upcomingLocations.isEmpty
                  ? r.PopUpLocation(
                      locationId: "123",
                      locationAddress: "Dummy",
                      locationDateStart: Timestamp.now(),
                      locationDateEnd: Timestamp.now(),
                      timestamp: Timestamp.now(),
                      geolocation: const GeoPoint(0, 0),
                      locationName: "Dummy",
                    )
                  : widget.restaurant.upcomingLocations[0],
              timestamp: Timestamp.now(),
              fulfilled: false,
            ),
          ),
        ),
      ],
      child: widget.isFront
          ? buildFrontCard(
              foodCardWidth,
              foodCardHeight,
            )
          : buildCard(
              context,
              foodCardWidth,
              foodCardHeight,
            ),
    );
  }

  Widget buildFrontCard(double width, double height) {
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
            transform: Matrix4.translationValues(position.dx, position.dy, 0)
              ..rotateZ(angle * pi / 180),
            child: Stack(
              alignment: Alignment.center,
              children: [
                buildCard(context, width, height),
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

  Widget buildCard(BuildContext context, double width, double height) {
    double scrollLimit = MediaQuery.of(context).size.height * 0.12;
    double startTracking = MediaQuery.of(context).size.height * 0.48;
    double opacitydelta = 1.0 / scrollLimit;

    return Stack(alignment: Alignment.center, children: [
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: dineTimeColorScheme.onSurface, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              // Notifications for Analytics

              if (scrollNotification is ScrollEndNotification) {
                if (_controller.position.pixels < scrollLimit) {
                } else if (_controller.position.pixels >= scrollLimit &&
                    _controller.position.pixels < startTracking) {
                  if (widget.origin != null) {
                    widget.services.clientAnalytics
                        .trackScreenView('MainDetails', widget.origin!);
                  } else {
                    widget.services.clientAnalytics
                        .trackScreenView('MainDetails', 'FYFPage');
                  }
                } else if (_controller.position.pixels >= startTracking &&
                    _controller.position.pixels <
                        startTracking + _aboutAndStoryHeight) {
                  if (widget.origin != null) {
                    widget.services.clientAnalytics
                        .trackScreenView('AboutAndStory', widget.origin!);
                  } else {
                    widget.services.clientAnalytics
                        .trackScreenView('AboutAndStory', 'FYFPage');
                  }
                } else if (_controller.position.pixels >=
                        startTracking + _aboutAndStoryHeight &&
                    _controller.position.pixels <
                        startTracking + _photoGalleryHeight) {
                  if (widget.origin != null) {
                    widget.services.clientAnalytics
                        .trackScreenView('PhotoGallery', widget.origin!);
                  } else {
                    widget.services.clientAnalytics
                        .trackScreenView('PhotoGallery', 'FYFPage');
                  }
                } else if (_controller.position.pixels >=
                        startTracking + _photoGalleryHeight &&
                    _controller.position.pixels <
                        startTracking + _dietaryOptionsHeight) {
                  if (widget.origin != null) {
                    widget.services.clientAnalytics
                        .trackScreenView('DietOptions', widget.origin!);
                  } else {
                    widget.services.clientAnalytics
                        .trackScreenView('DietOptions', 'FYFPage');
                  }
                } else if (_controller.position.pixels >=
                        startTracking + _dietaryOptionsHeight &&
                    _controller.position.pixels <
                        startTracking + _menuItemsHeight) {
                  if (widget.origin != null) {
                    widget.services.clientAnalytics
                        .trackScreenView('Menu', widget.origin!);
                  } else {
                    widget.services.clientAnalytics
                        .trackScreenView('Menu', 'FYFPage');
                  }
                } else {
                  if (widget.origin != null) {
                    widget.services.clientAnalytics
                        .trackScreenView('UpcomingLocs', widget.origin!);
                  } else {
                    widget.services.clientAnalytics
                        .trackScreenView('UpcomingLocs', 'FYFPage');
                  }
                }
              }
              if (scrollNotification.metrics.pixels >= scrollLimit) {
                setState(() {
                  _isMainDetailsVisible = false;
                  _isBottomPreorderButtonVisible = true;
                });
              } else {
                setState(() {
                  _isMainDetailsVisible = true;
                  _isBottomPreorderButtonVisible = false;
                  if (scrollNotification.metrics.pixels <= 0) {
                    _opacity = 0.0;
                    _opacityPreorder = 0.0;
                  } else {
                    _opacity = scrollNotification.metrics.pixels * opacitydelta;
                    _opacityPreorder =
                        scrollNotification.metrics.pixels * opacitydelta;
                  }
                  if (scrollNotification.metrics.pixels >= 1.0) {
                    _opacityPreorder = 1.0;
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
                          height: height - 3,
                          restaurantCoverRef:
                              widget.restaurant.restaurantCoverRef,
                          services: widget.services,
                        ),
                        BackgroundShadow(width: width, height: height - 3),
                        mainDetails(width, height)
                      ],
                    ),
                    additionalDetails(),
                    const SizedBox(height: 70.0), // For preorder button
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      PreorderButton(
        clientAuth: widget.services.clientAuth,
        restaurantName: widget.restaurant.restaurantName,
        menu: widget.restaurant.menu,
        nextLocation: widget.restaurant.upcomingLocations.isEmpty
            ? null
            : widget.restaurant.upcomingLocations[0],
        preordersEnabled: widget.restaurant.preordersEnabled,
        isVisible: _isBottomPreorderButtonVisible,
      ),
    ]);
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
              key: _mainDetailsKey,
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
                  onMainDetails: true,
                ),
                CuisineDetails(
                  cuisine: widget.restaurant.cuisine,
                  pricing: widget.restaurant.pricing,
                  customerLocation: widget.customer.geolocation!,
                  locations: widget.restaurant.upcomingLocations,
                  onMainDetails: true,
                ),
                const SizedBox(height: 18),
                NextLocation(
                  upcomingLocations: widget.restaurant.upcomingLocations,
                  onMainDetails: true,
                ),
                const SizedBox(height: 7),
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
          left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
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
            onMainDetails: false,
          ),
          CuisineDetails(
            cuisine: widget.restaurant.cuisine,
            pricing: widget.restaurant.pricing,
            customerLocation: widget.customer.geolocation!,
            locations: widget.restaurant.upcomingLocations,
            onMainDetails: false,
          ),
          const SizedBox(height: 15),
          NextLocation(
            upcomingLocations: widget.restaurant.upcomingLocations,
            onMainDetails: false,
          ),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          AboutAndStory(
            key: _aboutAndStoryKey,
            restaurantBio: widget.restaurant.bio,
          ),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          PhotoGallery(
            key: _photoGalleryKey,
            gallery: widget.restaurant.gallery,
            clientStorage: widget.services.clientStorage,
          ),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          Dietary(key: _dietaryOptionsKey, menu: widget.restaurant.menu),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          Menu(
            key: _menuItemsKey,
            menu: widget.restaurant.menu,
          ),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          UpcomingLocations(
            key: _upcomingLocationsKey,
            customerLocation: widget.customer.geolocation!,
            popUpLocations: widget.restaurant.upcomingLocations,
          ),
        ],
      ),
    );
  }
}
