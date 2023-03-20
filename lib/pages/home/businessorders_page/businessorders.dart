import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:provider/provider.dart';

import 'widgets/businesspendingcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessOrderPage extends StatefulWidget {
  final Customer customer;
  const BusinessOrderPage({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<BusinessOrderPage> createState() => _BusinessOrderPageState();
}

class _BusinessOrderPageState extends State<BusinessOrderPage> {
  List<String> tabs = [
    "Pending",
    "Completed",
  ];
  int current = 0;

  Color boxColor(int index) =>
      current == index ? Color(0xFFFFF6EC) : Color(0xFFC4C4C4);
  Color tabColor(int index) =>
      current == index ? Colors.black : Color(0xFFC4C4C4);
  Color numberColor(int index) =>
      current == index ? dineTimeColorScheme.primary : Colors.white;

// Change (Hardcoded)
  double changePositionedOfLine() {
    switch (current) {
      case 0:
        return 0;
      case 1:
        return 142;
      default:
        return 0;
    }
  }

// Change (Hardcoded)
  double changeContainerWidth() {
    switch (current) {
      case 0:
        return 72;
      case 1:
        return 95;
      case 2:
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Services services = Provider.of<Services>(context);
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: height * 0.053),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.06),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              "Pre-Orders",
              style: dineTimeTypography.headlineLarge,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: width,
            height: height * 0.05,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: width,
                    height: height * 0.04,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: tabs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 10 : 23, top: 7),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    current = index;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      tabs[index],
                                      style: dineTimeTypography.headlineSmall
                                          ?.copyWith(color: tabColor(index)),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: boxColor(index),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        '200', //change with v
                                        style: TextStyle(
                                          color: numberColor(index),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.fastLinearToSlowEaseIn,
                  bottom: 0,
                  left: changePositionedOfLine(), // Change this
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedContainer(
                    margin: const EdgeInsets.only(left: 10),
                    width: changeContainerWidth(), // Change this
                    height: 3,
                    decoration: BoxDecoration(
                      color: dineTimeColorScheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastLinearToSlowEaseIn,
                  ),
                )
              ],
            ),
          ),
          BusinessPendingCard(
            customer: customer,
            preorderBag: preorderBag,
          )
        ],
      ),
    );
  }
}
