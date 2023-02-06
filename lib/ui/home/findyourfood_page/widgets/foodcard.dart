import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  bool _isMainDetailsVisible = true;

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

        return Positioned(top: 200, left: -100, child: child);
      case CardStatus.dislike:
        final child = stamp(
          color: Colors.red,
          text: 'lib/assets/dislike_logo.png',
          opacity: opacity,
        );

        return Positioned(top: 200, right: -100, child: child);
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
      opacity: opacity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: const RadialGradient(
                colors: [
                  Color.fromARGB(200, 255, 255, 255),
                  Colors.transparent,
                ],
                stops: [0.5, 1],
              ),
            ),
          ),
          Image.asset(text, height: 70, width: 70),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.9;
    double height = size.height * 0.77;

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
            if (scrollNotification.metrics.pixels >= 50) {
              setState(() {
                _isMainDetailsVisible = false;
              });
            } else {
              setState(() {
                _isMainDetailsVisible = true;
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
                      Visibility(
                        visible: _isMainDetailsVisible,
                        child: mainDetails(width, height),
                      ),
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
    return Container(
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
            name(dineTimeColorScheme.background),
            cuisineDetails(dineTimeColorScheme.background),
            const SizedBox(height: 18),
            widget.restaurant.upcomingLocations.isNotEmpty
                ? nextLocation(dineTimeColorScheme.background,
                    'lib/assets/location_white.png')
                : Container(),
            const SizedBox(height: 7),
            widget.restaurant.upcomingLocations.isNotEmpty
                ? nextDate(
                    dineTimeColorScheme.background, 'lib/assets/calendar.png')
                : Container(),
            const SizedBox(height: 7),
            widget.restaurant.upcomingLocations.isNotEmpty
                ? nextTime(dineTimeColorScheme.background,
                    'lib/assets/clock_white.png')
                : Container(),
          ],
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
          contact(),
          const SizedBox(height: 5),
          name(dineTimeColorScheme.onBackground),
          cuisineDetails(dineTimeColorScheme.onBackground),
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

  Widget contact() {
    return Row(
      children: [
        widget.restaurant.instagramHandle != null
            ? Padding(
                padding: const EdgeInsets.only(right: 15.0),
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
                              blurRadius: 20,
                              color: Color.fromARGB(255, 224, 224, 224),
                              spreadRadius: 5)
                        ]),
                    child: const CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('lib/assets/instagram.png'),
                    ),
                  ),
                ),
              )
            : Container(),
        widget.restaurant.website != null
            ? Padding(
                padding: const EdgeInsets.only(right: 15.0),
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
                                blurRadius: 20,
                                color: Color.fromARGB(255, 231, 231, 231),
                                spreadRadius: 5)
                          ]),
                      child: const CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('lib/assets/website.png'),
                      ),
                    ),
                  ),
                ))
            : Container(),
        widget.restaurant.email != null
            ? Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('mailto:${widget.restaurant.email!}'),
                  ),
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              color: Color.fromARGB(255, 224, 224, 224),
                              spreadRadius: 5)
                        ]),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Image(
                        image: AssetImage('lib/assets/email.png'),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget aboutAndStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Story',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 13),
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

  Widget photoOption(
      String imageName, ImageProvider<Object>? image, String imageDescription) {
    return Container(
      child: Column(
        children: [
          Text(
            imageName,
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.25,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                  image: image ??
                      const AssetImage("lib/assets/dinetime-orange.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              imageDescription,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontSize: 12.0,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget photoGallery() {
    List<r.GalleryImage> gallery = widget.restaurant.gallery;
    List<Widget> galleryChildren = [];
    List<Widget> galleryButtonChildren = [];
    final _controller = PageController();
    num count = 0;
    for (r.GalleryImage galleryImage in gallery) {
      galleryChildren.add(
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.5),
            image: DecorationImage(
                image: galleryImage.image, fit: BoxFit.cover, opacity: 0.8),
          ),
          child: Stack(
            children: [
              Container(),
              Positioned(
                top: 5,
                right: 5,
                child: Image.asset(
                  "lib/assets/expanded.png",
                  height: 15,
                  width: 15,
                ),
              ),
            ],
          ),
        ),
      );
      count += 1;
      if (count == 3) {
        break;
      }
    }
    for (r.GalleryImage galleryImage in gallery) {
      galleryButtonChildren.add(
        photoOption(galleryImage.imageName, galleryImage.image,
            galleryImage.imageDescription),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo Gallery',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 15.0),
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
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Image(
                                  image: AssetImage('lib/assets/x_button.png'),
                                  height: 25,
                                  width: 25),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Column(
                            children: [
                              Container(
                                width: 410,
                                height: 400,
                                child: PageView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _controller,
                                  children: galleryButtonChildren,
                                ),
                              ),
                              SmoothPageIndicator(
                                controller: _controller,
                                count: galleryChildren.length,
                                effect: const SwapEffect(
                                  activeDotColor: Colors.orange,
                                  dotColor: Colors.grey,
                                  dotHeight: 5,
                                  dotWidth: 5,
                                ),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget name(Color color) {
    return Text(
      widget.restaurant.restaurantName,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 25.0,
            color: color,
            fontWeight: FontWeight.normal,
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
                "3 Days Away",
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
