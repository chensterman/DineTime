import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/foodcard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindYourFood extends StatefulWidget {
  final AuthService clientAuth;
  final DatabaseService clientDB;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const FindYourFood({
    Key? key,
    required this.clientAuth,
    required this.clientDB,
    required this.clientStorage,
    required this.clientAnalytics,
  }) : super(key: key);

  @override
  State<FindYourFood> createState() => _FindYourFoodState();
}

class _FindYourFoodState extends State<FindYourFood> {
  @override
  Widget build(BuildContext context) {
    widget.clientAnalytics
        .getInstance()
        .logScreenView(screenClass: 'FYF', screenName: 'FYFPage');
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            topLocationBar(),
            const SizedBox(
              height: 20.0,
            ),
            ChangeNotifierProvider(
              create: (context) => CardProvider(
                customerId: widget.clientAuth.getCurrentUserUid()!,
                clientDB: widget.clientDB,
              ),
              builder: (context, child) {
                return buildCards(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget topLocationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await widget.clientAuth.signOut();
          },
          child: Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('lib/assets/location_arrow_black.png'),
              ),
              color: dineTimeColorScheme.onPrimary,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        const SizedBox(
          width: 13.0,
        ),
        FutureBuilder(
          future: widget.clientDB
              .customerLocationAddress(widget.clientAuth.getCurrentUserUid()!),
          builder: (context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasError) {
              return Text(
                "Error retrieving location",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 15.0, fontWeight: FontWeight.w500),
              );
              // On success.
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                snapshot.data!,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 15.0, fontWeight: FontWeight.w500),
              );
            } else {
              return Text(
                "Retrieving location...",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 15.0, fontWeight: FontWeight.w500),
              );
            }
          },
        ),
      ],
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
                    clientStorage: widget.clientStorage,
                  ),
                )
                .toList(),
          );
  }
}
