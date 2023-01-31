import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

import 'widgets/foodlistcardprocess.dart';

// Widget that displays list of saved restaurants for logged in customer
class Favorites extends StatelessWidget {
  final String customerId;
  const Favorites({Key? key, required this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.05),
        color: Colors.white,
        child: StreamBuilder<DocumentSnapshot>(
          // Customer document stream
          stream: DatabaseService().customerStream(customerId),
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
                        Padding(
                            padding: const EdgeInsets.only(left: 27),
                            child: Text("My Favorites",
                                style: Theme.of(context).textTheme.headline1)),
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 27, bottom: 20),
                            child: Text(
                                '${data['saved_businesses'].length} items',
                                style: Theme.of(context).textTheme.subtitle1)),
                      ],
                    );
                  }
                  // Return widget to process all document references
                  return FoodListCardProcess(
                      customerGeoPoint: data['geolocation'],
                      restaurantRef: data['saved_businesses'][index - 1]
                          ['restaurant_ref']);
                },
              );
            } else {
              return const LoadingScreen();
            }
          }),
        ));
  }
}
