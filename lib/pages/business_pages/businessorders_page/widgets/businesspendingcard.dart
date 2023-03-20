import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/preorderreceipt_page/preorderreceipt.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Cards that display list items in saved
class BusinessPendingCard extends StatelessWidget {
  final Customer customer;
  final PreorderBag preorderBag;
  const BusinessPendingCard({
    super.key,
    required this.customer,
    required this.preorderBag,
  });

  final double _cardHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    num subtotal = preorderBag.getSubtotal();
    DateTime preorderDate = preorderBag.timestamp.toDate();
    String preorderDateString =
        "${months[preorderDate.month - 1]} ${preorderDate.day}, ${preorderDate.year}";
    String preorderItemsString = "";
    int count = 0;
    for (PreorderItem? preorderItem in preorderBag.bag) {
      preorderItemsString +=
          "${preorderItem!.item.itemName} (${preorderItem.quantity})";
      count += 1;
      if (count != preorderBag.bag.length) {
        preorderItemsString += "  ·  ";
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        width: 70,
        height: _cardHeight,
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
                    builder: (context) => PreorderReceipt(
                      customer: customer,
                      preorderBag: preorderBag,
                    ),
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
                                    preorderBag.restaurant.restaurantName,
                                    style: dineTimeTypography.headlineMedium,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
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
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "\$$subtotal  ·  $preorderDateString  ·  Order #${preorderBag.preorderCode}",
                                style: dineTimeTypography.bodyMedium?.copyWith(
                                  color: dineTimeColorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                preorderItemsString,
                                style: dineTimeTypography.bodyMedium?.copyWith(
                                  color: dineTimeColorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
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
