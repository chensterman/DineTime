import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class PreorderConfirm extends StatefulWidget {
  const PreorderConfirm({
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
  State<PreorderConfirm> createState() => _PreorderConfirmState();
}

class _PreorderConfirmState extends State<PreorderConfirm> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        preorderMenu(context),
        confirmPreorderButton(),
      ],
    );
  }

  Widget preorderMenu(BuildContext context) {
    // Mock Data
    List<String> preOrderPhotoPath = [
      'lib/assets/food1.png',
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
      '/Users/jaypalamand/Dinetime/dinetime_mobile_mvp/lib/assets/vegan.png',
      '/Users/jaypalamand/Dinetime/dinetime_mobile_mvp/lib/assets/nut_free.png',
    ];
    //Mock Data
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      disabledBackgroundColor: Theme.of(context).colorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textStyle: Theme.of(context).textTheme.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ); // 50 px height, inf width
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Steph Curry's Pop-Up",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w100),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your Order is #609',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 15.0),
                    Image(
                        image: AssetImage('lib/assets/preordercheck.png'),
                        height: 80,
                        width: 80),
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                      child: Text(
                        "Congrats! You have skipped the line. Please complete your payment at Steph Curry’s Pop-Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                'Pre-Order Summary',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 5.0),
              ListView.builder(
                shrinkWrap: true, // add this line
                physics: NeverScrollableScrollPhysics(),
                itemCount: preOrderItemName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
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
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      preOrderPhotoPath[index],
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
                                preOrderItemName[index],
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
                                    '\$${preOrderPrices[index]}',
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
                  );
                },
              ),
              const Divider(),
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
              const SizedBox(height: 30.0),
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
                        opacity: 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: style,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Return to Home",
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
      ),
    );
  }

  Widget confirmPreorderButton() {
    // Button styled with pimary colors on ElevatedButton class for filled effect
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      disabledBackgroundColor: Theme.of(context).colorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textStyle: Theme.of(context).textTheme.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ); // 50 px height, inf width
    return Positioned(
      bottom: 40.0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        height: 40,
        child: Opacity(
          opacity: 0.9,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                context: context,
                builder: (context) => Stack(
                  alignment: Alignment.bottomCenter,
                  children: [preorderMenu(context)],
                ),
              );
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
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      "3",
                      style: TextStyle(
                        color: dineTimeColorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  "\$27.99",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
