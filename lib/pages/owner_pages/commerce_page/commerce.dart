import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/root/routing_page/routing.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/pendingcard.dart';
import 'widgets/completedcard.dart';

class Commerce extends StatefulWidget {
  final Restaurant restaurant;
  const Commerce({
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  State<Commerce> createState() => _CommerceState();
}

class _CommerceState extends State<Commerce> {
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
        return 95;
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    Text(
                      "Pre-Orders",
                      style: dineTimeTypography.headlineLarge,
                    ),
                    const Spacer(),
                    InkWell(
                      child: Icon(
                        Icons.settings,
                        color: dineTimeColorScheme.primary,
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
              ),
              const SizedBox(height: 20.0),
              preorderTabs(width, height),
              const SizedBox(height: 20.0),
              preordersList(services, height, current == 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget preorderTabs(double width, double height) {
    return SizedBox(
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
                      padding:
                          EdgeInsets.only(left: index == 0 ? 10 : 23, top: 7),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                        },
                        child: Text(
                          tabs[index],
                          style: dineTimeTypography.headlineSmall
                              ?.copyWith(color: tabColor(index)),
                        ),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         tabs[index],
                        //         style: dineTimeTypography.headlineSmall
                        //             ?.copyWith(color: tabColor(index)),
                        //       ),
                        //       const SizedBox(width: 10),
                        //       Container(
                        //         padding: EdgeInsets.all(5),
                        //         decoration: BoxDecoration(
                        //           color: boxColor(index),
                        //           borderRadius: BorderRadius.circular(5),
                        //         ),
                        //         child: Text(
                        //           '200', //change with v
                        //           style: TextStyle(
                        //             color: numberColor(index),
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                      ),
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
    );
  }

  Widget preordersList(Services services, double height, bool fulfilled) {
    return Container(
      height: height * 0.7,
      color: Colors.white,
      child: StreamBuilder<List<PreorderBag>>(
        // Customer document stream
        stream: services.clientDB.restaurantPreordersStream(
          widget.restaurant.restaurantId,
          current == 1,
        ),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            // On document loaded, convert document snapshot to map
            List<PreorderBag> preorderBags = snapshot.data!;
            // Generate ListView of all saved restaurants
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemCount: preorderBags.length,
              itemBuilder: (context, index) {
                // Return widget to process all document references
                return fulfilled
                    ? CompletedCard(preorderBag: preorderBags[index])
                    : PendingCard(preorderBag: preorderBags[index]);
              },
            );
          } else {
            return const LoadingScreen();
          }
        }),
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
                        style: dineTimeTypography.bodySmall
                            ?.copyWith(color: dineTimeColorScheme.primary),
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
}
