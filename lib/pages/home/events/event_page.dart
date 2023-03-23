import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:provider/provider.dart';

import '../../../models/event.dart';
import 'widgets/eventlistcard.dart';

// Widget that displays list of saved restaurants for logged in customer
class Events extends StatelessWidget {
  final Customer customer;
  const Events({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Event event = Event(
      eventId: "testEventId",
      eventName: "Test Event",
      bio: "we getting lit",
      cuisine: "good food",
      eventLogoRef: "",
      eventCoverRef: "",
      restaurantName: "Popup 1",
      pricing: 3,
      upcomingLocation: PopUpLocation(
        locationId: "01",
        locationAddress: "Location Address, WA 12345",
        locationDateStart: Timestamp.now(),
        locationDateEnd: Timestamp.now(),
        timestamp: Timestamp.now(),
        geolocation: const GeoPoint(47.60, -122.33),
        locationName: "Location Name",
      ),
    );
    double height = MediaQuery.of(context).size.height;
    Services services = Provider.of<Services>(context);
    services.clientAnalytics.trackScreenView('Events', 'Events');
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.05),
        color: Colors.white,
        child: StreamBuilder<List<Restaurant>>(
          // Customer document stream
          stream: services.clientDB.customerFavoritesStream(
              services.clientAuth.getCurrentUserUid()!),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              // On document loaded, convert document snapshot to map
              List<Restaurant> restaurants = snapshot.data!;
              // Generate ListView of all saved restaurants
              return ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8.0),
                itemCount: restaurants.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Initial text widgetrs
                    return SingleChildScrollView(
                      child: Scrollbar(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                "Events",
                                style: dineTimeTypography.headlineLarge,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10.0),
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'lib/assets/location_arrow_black.png'),
                                    ),
                                    color: dineTimeColorScheme.onPrimary,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 13.0,
                                ),
                                FutureBuilder(
                                  future: services.clientLocation
                                      .geoPointToAddress(customer.geolocation!),
                                  builder: (context,
                                      AsyncSnapshot<String?> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                        "Error retrieving location",
                                        style: dineTimeTypography.headlineSmall,
                                      );
                                      // On success.
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      String address = snapshot.data!;
                                      return Text(
                                        "Near $address",
                                        style: dineTimeTypography.titleSmall,
                                      );
                                    } else {
                                      return Text(
                                        "Retrieving location...",
                                        style: dineTimeTypography.headlineSmall,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  // Return widget to process all document references
                  return EventListCard(
                    customer: customer,
                    event: event,
                  );
                },
              );
            } else {
              return const LoadingScreen();
            }
          }),
        ));
  }
}
