import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/foodcard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindYourFood extends StatefulWidget {
  final Customer customer;
  const FindYourFood({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<FindYourFood> createState() => _FindYourFoodState();
}

class _FindYourFoodState extends State<FindYourFood> {
  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    services.clientAnalytics.trackScreenView('FYFPage');
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            topLocationBar(context),
            const SizedBox(
              height: 20.0,
            ),
            ChangeNotifierProvider(
              create: (context) => CardProvider(
                customerId: services.clientAuth.getCurrentUserUid()!,
                clientDB: services.clientDB,
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

  Widget topLocationBar(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await services.clientAuth.signOut();
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
          future: services.clientDB
              .customerGet(services.clientAuth.getCurrentUserUid()!),
          builder: (context, AsyncSnapshot<Customer?> snapshot) {
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
              Customer customer = snapshot.data!;
              return Text(
                "TEST",
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
    Services services = Provider.of<Services>(context);
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
                    services: services,
                  ),
                )
                .toList(),
          );
  }
}
