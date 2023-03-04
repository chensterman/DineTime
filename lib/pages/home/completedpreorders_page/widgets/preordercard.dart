import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/fooddisplay_page/fooddisplay.dart';
import 'package:dinetime_mobile_mvp/pages/home/preorderreciept_page/preorderreciept.dart';
import 'package:dinetime_mobile_mvp/pages/home/preorderreciept_page/preorderrecieptdisplay.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Cards that display list items in saved
class PreorderCard extends StatelessWidget {
  final Customer customer;
  final Restaurant restaurant;
  const PreorderCard({
    super.key,
    required this.customer,
    required this.restaurant,
  });

  final double _cardHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    double? distance;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        width: 70,
        height: 105,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 233, 233, 233).withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            // Tappable portion of card
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreorderRecieptDisplay(),
                  ),
                );
              },
              child: SizedBox(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text overflow works by wrapping text under Flexible widget
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 12.0, bottom: 5.0),
                                  child: Text(
                                    restaurant.restaurantName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 12.0, bottom: 5.0),
                                  child: Image(
                                    height: 15,
                                    width: 15,
                                    image: AssetImage(
                                        'lib/assets/forward_arrow.png'),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "\$40.99  ·  Jan. 03, 2023  ·  Order #609",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                      fontSize: 12.0,
                                    ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 2.0),
                              child: Text(
                                "Vegetable Biryani (3)  ·  Vegetable Samosas (1)",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        fontSize: 12.0,
                                        color: dineTimeColorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
