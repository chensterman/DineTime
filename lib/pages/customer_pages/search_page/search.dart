import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:provider/provider.dart';

import 'widgets/searchcard.dart';

// Widget that displays list of saved restaurants for logged in customer
class Search extends StatelessWidget {
  final Customer customer;
  const Search({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Services services = Provider.of<Services>(context);
    services.clientAnalytics.trackScreenView('Search', 'Search');
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.05),
        color: Colors.white,
        child: StreamBuilder<List<Restaurant>>(
          // Customer document stream
          stream: services.clientDB.customerAllStream(),
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
                                "Search",
                                style: dineTimeTypography.headlineLarge,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Text(
                                'Discover local pop-ups',
                                style: dineTimeTypography.bodyLarge?.copyWith(
                                  color: dineTimeColorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  // Return widget to process all document references
                  return SearchCard(
                    customer: customer,
                    restaurant: restaurants[index - 1],
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
