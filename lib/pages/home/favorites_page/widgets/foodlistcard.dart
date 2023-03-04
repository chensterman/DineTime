import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/fooddisplay_page/fooddisplay.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Cards that display list items in saved
class FoodListCard extends StatelessWidget {
  final Customer customer;
  final Restaurant restaurant;
  const FoodListCard({
    super.key,
    required this.customer,
    required this.restaurant,
  });

  final double _cardHeight = 75.0;

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    double? distance;
    if (restaurant.upcomingLocations.isNotEmpty) {
      distance = services.clientLocation.distanceBetweenTwoPoints(
        customer.geolocation!,
        restaurant.upcomingLocations[0].geolocation,
      );
    }
    String infoText = distance != null
        ? '${restaurant.cuisine}  ·  ${'\$' * restaurant.pricing}  ·  $distance mi'
        : '${restaurant.cuisine}  ·  ${'\$' * restaurant.pricing}';
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
                    const Color.fromARGB(255, 233, 233, 233).withOpacity(0.5),
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
                    fullscreenDialog: true,
                    builder: (context) => FoodDisplay(
                      customer: customer,
                      restaurant: restaurant,
                    ),
                  ),
                );
              },
              child: SizedBox(
                height: _cardHeight,
                child: Row(
                  children: <Widget>[
                    // Restaurant logo
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 55.0,
                        height: 55.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: FutureBuilder(
                          future: services.clientStorage
                              .getPhoto(restaurant.restaurantLogoRef),
                          builder: ((context,
                              AsyncSnapshot<ImageProvider<Object>?> snapshot) {
                            if (snapshot.hasError) {
                              return Container();
                              // On success
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return LogoDisplay(
                                  width: 40.0,
                                  height: 40.0,
                                  image: snapshot.data!);
                              // On loading
                            } else {
                              return const LogoDisplay(
                                width: 40.0,
                                height: 40.0,
                                isLoading: true,
                              );
                            }
                          }),
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
                                  restaurant.restaurantName,
                                  style: dineTimeTypography.headlineSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  infoText,
                                  style: dineTimeTypography.bodySmall?.copyWith(
                                    color: dineTimeColorScheme.onSurface,
                                  ),
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
                        restaurant.instagramHandle != null
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: () => launchUrl(Uri.parse(
                                      'https://www.instagram.com/${restaurant.instagramHandle!}')),
                                  child: Container(
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 5),
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
                        restaurant.website != null
                            ? Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: InkWell(
                                  onTap: () => launchUrl(Uri.parse(
                                      'https://${restaurant.website!}')),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Container(
                                      width: 25.0,
                                      height: 25.0,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 5),
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
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                            onTap: () async {
                              await services.clientDB.customerDeleteFavorite(
                                  customer.customerId, restaurant.restaurantId);
                            },
                            child: Container(
                              width: 25.0,
                              height: 25.0,
                              child: const Image(
                                height: 5,
                                width: 5,
                                image: AssetImage('lib/assets/trash.png'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                      ],
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
}
