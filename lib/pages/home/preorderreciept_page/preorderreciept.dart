import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/foodcard.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class PreorderReciept extends StatefulWidget {
  const PreorderReciept({
    Key? key,
    this.itemPrice,
    this.itemCount,
    this.option,
    this.specialInstructions,
  }) : super(key: key);

  final int? itemCount;
  final double? itemPrice;
  final String? option;
  final String? specialInstructions;

  @override
  State<PreorderReciept> createState() => _PreorderRecieptState();
}

class _PreorderRecieptState extends State<PreorderReciept> {
  @override
  Widget build(BuildContext context) {
    List<String> preOrderPhotoPath = [
      'lib/assets/food1.png',
    ];
    List<String> preOrderItemName = [
      'Biryani',
      'Sandwich',
    ];
    List<String> preOrderPrices = [
      '9.99',
      '12.99',
    ];
    List<String> preOrderChoice = [
      'Small (6 Pieces)',
      'Medium (12 Pieces)',
    ];
    List<String> preOrderSpecialInstructions = [
      'Not too Spicy',
      'More chicken',
    ];
    List<int> preOrderItemCount = [2, 3, 4];
    List<String> preOrderDietOptions = [
      'lib/assets/vegan.png',
      'lib/assets/nut_free.png',
    ];
    //Mock Data
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Steph Curry's Pop-Up",
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Pre-Order Reciept",
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontSize: 20.0, color: dineTimeColorScheme.primary),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Divider(),
            const SizedBox(
              height: 8.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Order Details",
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage('lib/assets/preordercheck_grey.png'),
                    height: 18,
                    width: 18),
                const SizedBox(width: 15.0),
                Text(
                  'Order #609',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage('lib/assets/locationsmallgrey.png'),
                    height: 18,
                    width: 18),
                const SizedBox(width: 15.0),
                Text(
                  'Seattle Fremont Brewery',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage('lib/assets/clock_grey.png'),
                    height: 18,
                    width: 18),
                const SizedBox(width: 15.0),
                Text(
                  'Ordered Jan 03, 2023 at 4:00 PM PST',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage('lib/assets/preorderbag_grey.png'),
                    height: 18,
                    width: 18),
                const SizedBox(width: 15.0),
                Text(
                  'Pickup up Jan 05, 2023 at 1:00 PM PST',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Divider(),
            const SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Order Summary",
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 60,
              margin: EdgeInsets.all(2),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'lib/assets/food1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Biryani',
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Text(
                              '9.99',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w100,
                                    color: dineTimeColorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Divider(),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Text(
                    "Sub Total",
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    "\$27.99",
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Positioned(
                  bottom: 40.0,
                  child: SizedBox(
                    width: 180,
                    height: 50,
                    child: Opacity(
                      opacity: 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View Pop-Up",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
