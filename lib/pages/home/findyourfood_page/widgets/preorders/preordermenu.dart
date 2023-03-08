import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/preorders/preorderbag.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'preorderoption.dart';

class PreorderMenu extends StatelessWidget {
  final List<MenuItem> menu;
  PreorderMenu({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    List<Widget> columnChildren = [];
    for (MenuItem menuItem in menu) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(PreorderOption(
        itemName: menuItem.itemName,
        itemDesc: menuItem.itemDescription,
        price: menuItem.itemPrice,
        itemImageRef: menuItem.itemImageRef,
        dietaryTags: menuItem.dietaryTags,
        clientStorage: services.clientStorage,
      ));
      columnChildren.add(
        const SizedBox(height: 12.0),
      );
      columnChildren.add(
        const Divider(
          color: Color.fromARGB(95, 158, 158, 158),
          height: 1,
        ),
      );
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        preorderMenu(context, columnChildren),
        viewPreorderButton(context),
      ],
    );
  }

  Widget preorderMenu(BuildContext context, List<Widget> columnChildren) {
    columnChildren.add(
      const SizedBox(height: 70.0),
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        builder: (_, controller) => Padding(
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
                        "View Card",
                        style: dineTimeTypography.bodySmall
                            ?.copyWith(color: dineTimeColorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Our Menu',
                  style: dineTimeTypography.headlineMedium,
                ),
              ),
              const SizedBox(height: 5.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: columnChildren,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget viewPreorderButton(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: dineTimeColorScheme.onPrimary,
      disabledBackgroundColor: dineTimeColorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: dineTimeColorScheme.primary,
      textStyle: dineTimeTypography.headlineSmall,
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
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                context: context,
                builder: (context) => PreorderBag(),
              );
            },
            style: style,
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/cart_white.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  "View Pre-Order",
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
