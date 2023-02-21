import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/foodcard.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodDisplay extends StatelessWidget {
  final Customer customer;
  final Restaurant restaurant;
  const FoodDisplay({
    required this.customer,
    required this.restaurant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.08,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: FoodCard(
            customer: customer,
            restaurant: restaurant,
            isFront: false,
            services: services,
          ),
        ));
  }
}
