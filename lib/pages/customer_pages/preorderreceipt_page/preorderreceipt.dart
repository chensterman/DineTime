import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/fooddisplay_page/fooddisplay.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

import 'widgets/preorderreceiptitem.dart';

class PreorderReceipt extends StatelessWidget {
  final Customer customer;
  final PreorderBag preorderBag;
  const PreorderReceipt({
    super.key,
    required this.customer,
    required this.preorderBag,
  });

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    List<Widget> columnChildren = [];
    services.clientAnalytics.trackScreenView("preorder_receipt", "Preorders");
    for (PreorderItem? preorderItem in preorderBag.bag) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(PreorderReceiptItem(
          quantity: preorderItem!.quantity,
          menuItem: preorderItem.item,
          clientStorage: services.clientStorage));
      columnChildren.add(
        const SizedBox(height: 12.0),
      );
    }

    num totalPrice = 0;
    for (PreorderItem? preorderItem in preorderBag.bag) {
      totalPrice += preorderItem!.item.itemPrice * preorderItem.quantity;
    }

    Timestamp dateStart = preorderBag.location.locationDateStart;
    String periodStart = dateStart.toDate().hour >= 12 ? "PM" : "AM";
    String timeZoneName = dateStart.toDate().timeZoneName;
    num hourStart = dateStart.toDate().hour % 12;
    String hourStartString =
        (hourStart / 10).floor() == 0 ? "0$hourStart" : "$hourStart";
    num minuteStart = dateStart.toDate().minute;
    String minuteStartString =
        (minuteStart / 10).floor() == 0 ? "0$minuteStart" : "$minuteStart";
    String pickupTime =
        "$hourStartString:$minuteStartString $periodStart $timeZoneName";

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: dineTimeColorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: dineTimeColorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                preorderBag.restaurant.restaurantName,
                style: dineTimeTypography.headlineMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'Pre-Order Receipt',
                style: dineTimeTypography.bodyMedium?.copyWith(
                  color: dineTimeColorScheme.primary,
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                'Order Details',
                style: dineTimeTypography.headlineSmall,
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                      image: AssetImage('lib/assets/preordercheck_grey.png'),
                      height: 18,
                      width: 18),
                  const SizedBox(width: 15.0),
                  Text(
                    "Order #${preorderBag.preorderCode}",
                    style: dineTimeTypography.bodyMedium?.copyWith(
                      color: dineTimeColorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                      image: AssetImage('lib/assets/locationsmallgrey.png'),
                      height: 18,
                      width: 18),
                  const SizedBox(width: 15.0),
                  Text(
                    preorderBag.location.locationName,
                    style: dineTimeTypography.bodyMedium?.copyWith(
                      color: dineTimeColorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                      image: AssetImage('lib/assets/clock_grey.png'),
                      height: 18,
                      width: 18),
                  const SizedBox(width: 15.0),
                  Text(
                    'Pickup at $pickupTime',
                    style: dineTimeTypography.bodyMedium?.copyWith(
                      color: dineTimeColorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: columnChildren,
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text(
                      "Sub Total",
                      style: dineTimeTypography.headlineMedium,
                    ),
                    const Spacer(),
                    Text(
                      "\$$totalPrice",
                      style: dineTimeTypography.headlineMedium?.copyWith(
                        color: dineTimeColorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              ButtonFilled(
                text: "View Pop-Up",
                isDisabled: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => FoodDisplay(
                        customer: customer,
                        restaurant: preorderBag.restaurant,
                        origin: "Preorders",
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
