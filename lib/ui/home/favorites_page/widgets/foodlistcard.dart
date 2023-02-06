import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/ui/home/fooddisplay_page/fooddisplay.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

// Cards that display list items in saved
class FoodListCard extends StatelessWidget {
  final bool isLoading;
  final GeoPoint? customerGeoPoint;
  final RestaurantPreview? restaurantPreview;
  const FoodListCard({
    super.key,
    required this.isLoading,
    this.customerGeoPoint,
    this.restaurantPreview,
  });
  // Function called when user hits delete button
  // TODO: connect this to backend
  void deleteFavorite() {}

  final double _cardHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Loading version of FoodListCard
      return loadingFoodListCard();
    } else {
      // Get distance between customer and first location
      // If no upcoming locations, is null
      List<PopUpLocation> upcomingLocations =
          restaurantPreview!.upcomingLocations;
      double? distance = upcomingLocations.isNotEmpty
          ? LocationService().distanceBetweenTwoPoints(
              customerGeoPoint!, upcomingLocations[0].geocode)
          : null;
      // Card item
      return fullFoodListCard(context, distance);
    }
  }

  // Loading version of the FoodListCard
  Widget loadingFoodListCard() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SizedBox(
            width: 70,
            height: 70,
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 233, 233, 233)
                          .withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: _cardHeight,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ))));
  }

  // Full version of the FoodListCard
  Widget fullFoodListCard(BuildContext context, double? distance) {
    String infoText = distance != null
        ? '${restaurantPreview!.cuisine!}  ·  ${'\$' * restaurantPreview!.pricing}  ·  $distance mi'
        : '${restaurantPreview!.cuisine!}  ·  ${'\$' * restaurantPreview!.pricing}';
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SizedBox(
            width: 70,
            height: 70,
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 233, 233, 233).withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  // Tappable portion of card
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FoodDisplay(
                                  restaurantId: restaurantPreview!.restaurantId,
                                )),
                      );
                    },
                    child: SizedBox(
                      height: _cardHeight,
                      child: Row(
                        children: <Widget>[
                          // Restaurant logo
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: restaurantPreview!.restaurantLogo,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: dineTimeColorScheme.primary,
                                      width: 2),
                                ),
                              ),
                            ),
                          ),
                          // Name, cuisine, pricing, distance portion
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
                                        restaurantPreview!.restaurantName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            ?.copyWith(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Flexible(
                                      child: Text(
                                        infoText,
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
                          // Instagram link, website link (only shown if exists)
                          Row(
                            children: [
                              restaurantPreview!.instagramHandle != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: InkWell(
                                        onTap: () => launchUrl(Uri.parse(
                                            'https://www.instagram.com/${restaurantPreview!.instagramHandle!}')),
                                        child: Container(
                                          width: 25.0,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 5),
                                              boxShadow: const [
                                                BoxShadow(
                                                    blurRadius: 25,
                                                    color: Color.fromARGB(
                                                        255, 224, 224, 224),
                                                    spreadRadius: 5)
                                              ]),
                                          child: const Image(
                                            height: 5,
                                            width: 5,
                                            image: AssetImage(
                                                'lib/assets/instagram_orange.png'),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              restaurantPreview!.website != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: InkWell(
                                        onTap: () => launchUrl(Uri.parse(
                                            'https://${restaurantPreview!.website!}')),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: Container(
                                            width: 25.0,
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 5),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      blurRadius: 25,
                                                      color: Color.fromARGB(
                                                          255, 224, 224, 224),
                                                      spreadRadius: 5)
                                                ]),
                                            child: const Image(
                                              height: 5,
                                              width: 5,
                                              image: AssetImage(
                                                  'lib/assets/website.png'),
                                            ),
                                          ),
                                        ),
                                      ))
                                  : Container(),
                              const SizedBox(
                                width: 8.0,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}
