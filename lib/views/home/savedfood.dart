import 'package:dinetime_mobile_mvp/theme/components/foodcard.dart';
import 'package:dinetime_mobile_mvp/views/home/foodcarddisplay.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

// Widget that displays list of saved restaurants for logged in customer
class SavedFood extends StatefulWidget {
  final String customerId;
  const SavedFood({Key? key, required this.customerId}) : super(key: key);

  @override
  State<SavedFood> createState() => _SavedFoodState();
}

class _SavedFoodState extends State<SavedFood> {
  final double _cardHeight = 75.0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.05),
        child: StreamBuilder<DocumentSnapshot>(
          // Customer document stream
          stream: DatabaseService().customerStream(widget.customerId),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              // On document loaded, convert document snapshot to map
              DocumentSnapshot documentSnapshot = snapshot.data!;
              Map<String, dynamic> data =
                  documentSnapshot.data()! as Map<String, dynamic>;
              // Generate ListView of all saved restaurants
              return ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8.0),
                itemCount: data['saved_businesses'].length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Initial text widgetrs
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Favorites",
                            style: Theme.of(context).textTheme.headline1),
                        Text('${data['saved_businesses'].length} items',
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    );
                  }
                  // Return widget to process all document references
                  return foodListCardProcess(data['geolocation'],
                      data['saved_businesses'][index - 1]['restaurant_ref']);
                },
              );
            } else {
              return const LoadingScreen();
            }
          }),
        ));
  }

  Widget foodListCardProcess(
      GeoPoint customerGeoPoint, DocumentReference restaurantRef) {
    return FutureBuilder(
      // Future to retrieve document data of restaurant reference
      future: DatabaseService().getRestaurantPreview(restaurantRef.id),
      builder: (context, AsyncSnapshot<RestaurantPreview> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // On loaded, process into FoodListCard
          RestaurantPreview restaurantPreview = snapshot.data!;
          return foodListCard(
            false,
            customerGeoPoint,
            restaurantPreview,
          );
        } else if (snapshot.hasError) {
          // On error
          return const Text('Error');
        } else {
          // While still loading, return loading version of FoodListCard
          return foodListCard(true, null, null);
        }
      },
    );
  }

  Widget foodListCard(bool isLoading, GeoPoint? customerGeoPoint,
      RestaurantPreview? restaurantPreview) {
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
      return fullFoodListCard(context, distance, restaurantPreview);
    }
  }

  // Loading version of the FoodListCard
  Widget loadingFoodListCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
    );
  }

  // Full version of the FoodListCard
  Widget fullFoodListCard(BuildContext context, double? distance,
      RestaurantPreview? restaurantPreview) {
    String infoText = distance != null
        ? '${restaurantPreview!.cuisine!} - ${'\$' * restaurantPreview.pricing} - $distance mi'
        : '${restaurantPreview!.cuisine!} - ${'\$' * restaurantPreview.pricing}';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Tappable portion of card
      child: InkWell(
        onTap: () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FoodCardDisplay(
                        restaurantId: restaurantPreview.restaurantId,
                      )),
            );
          }
        },
        child: SizedBox(
          height: _cardHeight,
          child: Row(
            children: [
              // Restaurant logo
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // TODO: Display image based on availability of user uploaded image
                      image: restaurantPreview!.restaurantLogo,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
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
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      fontSize: 14.0,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Flexible(
                          child: Text(
                            infoText,
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
                              width: 30.0,
                              height: 30.0,
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
                        )
                      : Container(),
                  restaurantPreview!.website != null
                      ? Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                            onTap: () => launchUrl(Uri.parse(
                                'https://${restaurantPreview!.website!}')),
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  // Display image based on availability of user uploaded image
                                  image: AssetImage('lib/assets/inbox.png'),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: () async {
                        await DatabaseService().deleteCustomerSaved(
                            widget.customerId, restaurantPreview.restaurantId);
                      },
                      child: Container(
                        width: 30.0,
                        height: 30.0,
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
                  ),
                  const SizedBox(
                    width: 8.0,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
