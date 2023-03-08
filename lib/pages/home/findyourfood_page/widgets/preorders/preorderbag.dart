import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/preorders/preorderconfirm.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class PreorderBag extends StatelessWidget {
  PreorderBag({
    Key? key,
  }) : super(key: key);

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
    'lib/assets/vegan.png',
    'lib/assets/nut_free.png',
  ];
  //Mock Data

  @override
  build(context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        preorderBag(context),
        confirmPreorderButton(context),
      ],
    );
  }

  Widget preorderBag(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.84,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
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
                    children: [
                      const Image(
                          image: AssetImage('lib/assets/back_arrow.png'),
                          height: 12,
                          width: 12),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Pre-Order Bag',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 2),
              Text(
                "Steph Curry's Pop-Up",
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w100),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
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
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                      image: AssetImage('lib/assets/clock_grey.png'),
                      height: 18,
                      width: 18),
                  const SizedBox(width: 15.0),
                  Text(
                    'Pickup before 6:00 PM PST',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true, // add this line
                physics: NeverScrollableScrollPhysics(),
                itemCount: preOrderItemName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(10),
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
                                  width: 60,
                                  height: 60,
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
                                    ),
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
                                  const SizedBox(width: 15.0),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        preOrderDietOptions[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    preOrderChoice[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Text(
                                    ", ",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    preOrderSpecialInstructions[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
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
                      style: dineTimeTypography.headlineMedium,
                    ),
                    Spacer(),
                    Text(
                      "\$27.99",
                      style: dineTimeTypography.headlineMedium?.copyWith(
                        color: dineTimeColorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  "Note: You will need to complete your official payment at the Pop-Up. Pre-Ordering items only secures your place in line.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmPreorderButton(BuildContext context) {
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
                builder: (context) => const PreorderConfirm(),
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
