import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/findyourfood_page/widgets/foodcard.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodDisplay extends StatelessWidget {
  final Customer customer;
  final Restaurant restaurant;
  final String origin;
  const FoodDisplay({
    required this.customer,
    required this.restaurant,
    required this.origin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: dineTimeColorScheme.onPrimary,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: dineTimeColorScheme.onBackground,
            ),
            onPressed: () {
              if (origin == "Preorders") {
                services.clientAnalytics
                    .trackScreenView('preorder_receipt', origin);
              } else {
                services.clientAnalytics.trackScreenView(origin, origin);
              }
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: FoodCard(
              customer: customer,
              restaurant: restaurant,
              isFront: false,
              services: services,
              origin: 'Favorites'),
        ));
  }
}
