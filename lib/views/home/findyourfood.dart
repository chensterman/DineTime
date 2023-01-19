import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/services/analytics_service.dart';
import 'package:dinetime_mobile_mvp/views/home/foodcard.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:provider/provider.dart';

class FindYourFood extends StatefulWidget {
  const FindYourFood({Key? key}) : super(key: key);

  @override
  State<FindYourFood> createState() => _FindYourFoodState();
}

class _FindYourFoodState extends State<FindYourFood> {
  @override
  Widget build(BuildContext context) {
    AnalyticsService()
        .getInstance()
        .logScreenView(screenClass: 'FYF', screenName: 'FYFPage');
    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider(
          create: (context) =>
              CardProvider(customerId: '03xUN3CqYlRNwukQAorq1G748h62'),
          builder: (context, child) {
            return buildCards(context);
          },
        ),
      ),
    );
  }

  Widget buildCards(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    final restaurants = provider.restaurants;

    return restaurants.isEmpty
        ? SizedBox(
            height: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Restart',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);

                provider.resetUsers();
              },
            ),
          )
        : Stack(
            children: restaurants
                .map((restaurant) => FoodCard(
                      restaurant: restaurant,
                      isFront: restaurants.last == restaurant,
                    ))
                .toList(),
          );
  }
}
