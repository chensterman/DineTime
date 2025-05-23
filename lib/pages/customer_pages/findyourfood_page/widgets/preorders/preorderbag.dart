import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../blocs/preorderbag/preorderbag_bloc.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'preorderconfirm.dart';
import 'preorderoption.dart';
import 'preorderpayment.dart';

class PreorderBag extends StatelessWidget {
  final AuthService clientAuth;
  final String restaurantName;
  final PopUpLocation nextLocation;
  final PreorderBagBloc preorderBagBloc;
  const PreorderBag({
    Key? key,
    required this.clientAuth,
    required this.restaurantName,
    required this.nextLocation,
    required this.preorderBagBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    services.clientAnalytics.trackScreenView('preorder_bag', 'Preorders');
    return BlocBuilder<PreorderBagBloc, PreorderBagState>(
        bloc: preorderBagBloc,
        builder: (context, state) {
          if (state is PreorderBagData) {
            List<Widget> columnChildren = [];
            for (PreorderItem? preorderItem in state.preorderBag.bag) {
              columnChildren.add(const SizedBox(
                height: 10.0,
              ));
              columnChildren.add(PreorderOption(
                menuItem: preorderItem!.item,
                clientStorage: services.clientStorage,
                preorderBagBloc: preorderBagBloc,
              ));
              columnChildren.add(
                const SizedBox(height: 12.0),
              );
            }

            int totalQuantity = 0;
            num totalPrice = 0;
            for (PreorderItem? preorderItem in state.preorderBag.bag) {
              totalQuantity += preorderItem!.quantity;
              totalPrice += preorderItem.item.itemPrice * preorderItem.quantity;
            }

            Timestamp dateStart = nextLocation.locationDateStart;
            String periodStart = dateStart.toDate().hour >= 12 ? "PM" : "AM";
            String timeZoneName = dateStart.toDate().timeZoneName;
            num hourStart = dateStart.toDate().hour % 12;
            String hourStartString =
                (hourStart / 10).floor() == 0 ? "0$hourStart" : "$hourStart";
            num minuteStart = dateStart.toDate().minute;
            String minuteStartString = (minuteStart / 10).floor() == 0
                ? "0$minuteStart"
                : "$minuteStart";
            String pickupTime =
                "$hourStartString:$minuteStartString $periodStart $timeZoneName";

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

            String pickupDate =
                '${months[dateStart.toDate().month - 1]} ${dateStart.toDate().day}, ${dateStart.toDate().year}';

            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              expand: false,
              builder: (_, controller) => Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: const [
                            Image(
                                image: AssetImage('lib/assets/back_arrow.png'),
                                height: 12,
                                width: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Pre-Order Bag',
                      style: dineTimeTypography.headlineMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      restaurantName,
                      style: dineTimeTypography.bodyMedium?.copyWith(
                        color: dineTimeColorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Image(
                            image:
                                AssetImage('lib/assets/locationsmallgrey.png'),
                            height: 18,
                            width: 18),
                        const SizedBox(width: 15.0),
                        Text(
                          nextLocation.locationName,
                          style: dineTimeTypography.bodyMedium?.copyWith(
                            color: dineTimeColorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Image(
                            image: AssetImage('lib/assets/clock_grey.png'),
                            height: 18,
                            width: 18),
                        const SizedBox(width: 15.0),
                        Text(
                          'Pickup at $pickupTime on $pickupDate',
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
                    // const Padding(
                    //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    //   child: Text(
                    //     "Note: You will need to complete your official payment at the Pop-Up. Pre-Ordering items only secures your place in line.",
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       fontStyle: FontStyle.italic,
                    //     ),
                    //   ),
                    // ),
                    // Text(
                    //   "Note: You will need to complete your official payment at the Pop-Up. Pre-Ordering items only secures your place in line.",
                    //   style: dineTimeTypography.bodySmall?.copyWith(
                    //     color: dineTimeColorScheme.primary,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    confirmPreorderButton(context, totalQuantity, totalPrice),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget confirmPreorderButton(
      BuildContext context, int totalQuantity, num totalPrice) {
    // Button styled with pimary colors on ElevatedButton class for filled effect
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: dineTimeColorScheme.onPrimary,
      disabledBackgroundColor: dineTimeColorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: dineTimeColorScheme.primary,
      textStyle: dineTimeTypography.headlineSmall,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ); // 50 px height, inf width
    Services services = Provider.of<Services>(context);
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        height: 40,
        child: Opacity(
          opacity: 0.9,
          child: ElevatedButton(
            onPressed: () async {
              try {
                await makePayment((totalPrice * 100).toString(), restaurantName,
                        clientAuth.getCurrentUserEmail()!)
                    .then((value) {
                  services.clientAnalytics
                      .trackEventNum('confirm_preorder', totalPrice.toDouble());
                  preorderBagBloc.add(
                    PreorderBagSubmit(
                      customerId: services.clientAuth.getCurrentUserUid()!,
                      customerEmail: services.clientAuth.getCurrentUserEmail()!,
                    ),
                  );
                  Navigator.pop(context);
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    context: context,
                    builder: (context) => PreorderConfirm(
                      restaurantName: restaurantName,
                      totalPrice: totalPrice,
                    ),
                  );
                }).onError((error, stackTrace) {
                  throw Exception(error);
                });
              } on StripeException catch (e) {
                print('Error is:---> $e');
                AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          Text("Payment Failed"),
                        ],
                      ),
                    ],
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
            style: style,
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/preorder_white.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Confirm Pre-Order",
                  style: dineTimeTypography.bodySmall?.copyWith(
                    color: dineTimeColorScheme.onPrimary,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "$totalQuantity",
                      style: dineTimeTypography.bodySmall?.copyWith(
                        color: dineTimeColorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "\$$totalPrice",
                  style: dineTimeTypography.bodySmall?.copyWith(
                    color: dineTimeColorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
