import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedFood extends StatefulWidget {
  final String customerId;
  const SavedFood({Key? key, required this.customerId}) : super(key: key);

  @override
  State<SavedFood> createState() => _SavedFoodState();
}

class _SavedFoodState extends State<SavedFood> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.05),
        child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService().customerStream(widget.customerId),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot = snapshot.data!;
              Map<String, dynamic> data =
                  documentSnapshot.data()! as Map<String, dynamic>;
              return ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8.0),
                itemCount: data['saved_businesses'].length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
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
                  return FoodListCardProcess(
                      customerGeoPoint: data['geolocation'],
                      restaurantRef: data['saved_businesses'][index - 1]);
                },
              );
            } else {
              return const LoadingScreen();
            }
          }),
        ));
  }
}

class FoodListCardProcess extends StatelessWidget {
  final GeoPoint customerGeoPoint;
  final DocumentReference restaurantRef;
  const FoodListCardProcess({
    super.key,
    required this.customerGeoPoint,
    required this.restaurantRef,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getRestaurantPreview(restaurantRef.id),
      builder: (context, AsyncSnapshot<RestaurantPreview> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          RestaurantPreview restaurantPreview = snapshot.data!;
          return FoodListCard(
            isLoading: false,
            customerGeoPoint: customerGeoPoint,
            restaurantPreview: restaurantPreview,
          );
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return const FoodListCard(isLoading: true);
        }
      },
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
      );
    } else {
      // Get distance
      List<PopUpLocation> upcomingLocations =
          restaurantPreview!.upcomingLocations;
      double? distance = upcomingLocations.isNotEmpty
          ? LocationService().distanceBetweenTwoPoints(
              customerGeoPoint!, upcomingLocations[0].geocode)
          : null;
      // Card item
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // Tappable portion of card
        child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // Display image based on availability of user uploaded image
                        image: restaurantPreview!.restaurantLogo,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurantPreview!.restaurantName,
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 16.0,
                                  )),
                      const SizedBox(height: 5.0),
                      Row(children: [
                        Text(restaurantPreview!.cuisine!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontSize: 14.0)),
                        horizontalTextDivider(context),
                        Text('\$' * restaurantPreview!.pricing,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontSize: 14.0)),
                        horizontalTextDivider(context),
                        distance != null
                            ? Text('$distance mi',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontSize: 14.0))
                            : Container(),
                      ]),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(children: [
                    restaurantPreview!.instagramHandle != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://www.instagram.com/${restaurantPreview!.instagramHandle!}')),
                              child: Container(
                                width: 35.0,
                                height: 35.0,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    // Display image based on availability of user uploaded image
                                    image:
                                        AssetImage('lib/assets/instagram.png'),
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
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://${restaurantPreview!.website!}')),
                              child: Container(
                                width: 35.0,
                                height: 35.0,
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
                  ]),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget horizontalTextDivider(BuildContext context) {
    return Text(" - ",
        style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14.0));
  }
}
