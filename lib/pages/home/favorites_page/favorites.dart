import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:provider/provider.dart';

import 'widgets/foodlistcard.dart';

// Widget that displays list of saved restaurants for logged in customer
class Favorites extends StatelessWidget {
  final Customer customer;
  const Favorites({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Services services = Provider.of<Services>(context);
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
                                "My Favorites",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Text('${restaurants.length} items',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontSize: 15,
                                      )),
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
                  return FoodListCard(
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
