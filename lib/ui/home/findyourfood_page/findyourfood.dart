import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/main.dart';
import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/services/analytics_service.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/ui/home/findyourfood_page/widgets/foodcard.dart';
import 'package:dinetime_mobile_mvp/ui/onboarding/signin_page/signin.dart';
import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await AuthService().signOut();
                  },
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.contain,
                        image:
                            AssetImage('lib/assets/location_arrow_black.png'),
                      ),
                      color: dineTimeColorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Bellevue, WA 98004",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  CardProvider(customerId: '03xUN3CqYlRNwukQAorq1G748h62'),
              builder: (context, child) {
                return buildCards(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCards(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    final restaurants = provider.restaurants;

    return restaurants.isEmpty
        ? const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: restaurants
                .map(
                  (restaurant) => FoodCard(
                    restaurant: restaurant,
                    isFront: restaurants.last == restaurant,
                  ),
                )
                .toList(),
          );
  }
}
