import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/content/menuoption.dart';

class Menu extends StatelessWidget {
  final List<r.MenuItem> menu;
  const Menu({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    List<Widget> columnChildren = [];
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(MenuOption(
        itemName: menuItem.itemName,
        itemDesc: menuItem.itemDescription,
        price: menuItem.itemPrice,
        itemImageRef: menuItem.itemImageRef,
        dietaryTags: menuItem.dietaryTags,
        clientStorage: services.clientStorage,
      ));
      columnChildren.add(
        const Divider(
          color: Color.fromARGB(95, 158, 158, 158),
          height: 1,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Menu',
          style: dineTimeTypography.headlineMedium,
        ),
        const SizedBox(
          height: 10,
        ),
        menu.isEmpty
            ? Text(
                'No menu items.',
                style: dineTimeTypography.bodyMedium?.copyWith(
                  color: dineTimeColorScheme.onSurface,
                ),
              )
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: dineTimeColorScheme.onSurface, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columnChildren,
                ),
              ),
      ],
    );
  }
}
