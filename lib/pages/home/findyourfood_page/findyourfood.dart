import 'package:dinetime_mobile_mvp/pages/root/routing_page/routing.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/provider/cardprovider.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/foodcard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    services.clientAnalytics.trackScreenView('FYFPage', 'FYFPage');
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
                clientAnalytics: services.clientAnalytics,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20.0),
          const Spacer(),
          Container(
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
          const SizedBox(
            width: 13.0,
          ),
          FutureBuilder(
            future: services.clientLocation
                .geoPointToAddress(widget.customer.geolocation!),
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
                String address = snapshot.data!;
                return Text(
                  address,
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
          const Spacer(),
          InkWell(
            child: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
              size: 20.0,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return settingsDialog(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget settingsDialog(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      const Image(
                          image: AssetImage('lib/assets/back_arrow.png'),
                          height: 12,
                          width: 12),
                      const SizedBox(width: 10),
                      Text(
                        "Go Back",
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontSize: 12.0,
                            fontFamily: 'Lato',
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ButtonFilled(
                text: "Log Out",
                isDisabled: false,
                onPressed: () {
                  services.clientAuth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const Routing(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ButtonFilled(
                text: "Delete Account",
                isDisabled: false,
                onPressed: () async {
                  Navigator.pop(context);
                  String customerId = services.clientAuth.getCurrentUserUid()!;
                  await services.clientAuth.deleteAccount();
                  await services.clientDB.customerDelete(customerId);
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const Routing(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20.0),
              ButtonOutlined(
                text: "Privacy Policy",
                onPressed: () => launchUrl(
                  Uri.parse(
                      "https://app.termly.io/document/privacy-policy/fe314525-5052-4111-b6ab-248cd2aa41c9"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCards(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    Services services = Provider.of<Services>(context);
    final restaurants = provider.restaurants;
    final isLoading = provider.isLoading;
    if (isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (restaurants.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("You have swiped through all of the Food Cards."),
        ),
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: restaurants
            .map(
              (restaurant) => FoodCard(
                customer: widget.customer,
                restaurant: restaurant,
                isFront: restaurants!.last == restaurant,
                services: services,
              ),
            )
            .toList(),
      );
    }
  }
}
