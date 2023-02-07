import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;

class Menu extends StatelessWidget {
  final List<r.MenuItem> menu;
  const Menu({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [];
    num count = 0;
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(menuOption(context, 12.0, menuItem.itemName,
          menuItem.itemDescription!, menuItem.itemPrice, menuItem.itemPhoto));
      columnChildren.add(
        const Divider(
          color: Color.fromARGB(95, 158, 158, 158),
          height: 1,
        ),
      );
      count += 1;
      if (count == 3) {
        break;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Our Menu',
              style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            menuButton(context),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          ),
        ),
      ],
    );
  }

  Widget menuOption(BuildContext context, double padding, String itemName,
      String itemDesc, num price, ImageProvider<Object>? itemImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$' + price.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(
                                  fontSize: 14.0,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          'lib/assets/vegan.png',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          'lib/assets/nut_free.png',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 10.0),
                        Image.asset(
                          'lib/assets/vegetarian.png',
                          width: 15,
                          height: 15,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      child: Text(
                        itemDesc,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontSize: 10.0,
                              fontFamily: 'Lato',
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.5),
                      image: DecorationImage(
                          image: itemImage ??
                              const AssetImage(
                                  "lib/assets/dinetime-orange.png"),
                          fit: BoxFit.cover,
                          opacity: 0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget menuButton(BuildContext context) {
    List<Widget> columnChildren = [];
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(menuOption(context, 0, menuItem.itemName,
          menuItem.itemDescription!, menuItem.itemPrice, menuItem.itemPhoto));
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
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return menuDialog(context, columnChildren);
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 135,
            height: 25,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        image: AssetImage('lib/assets/view_menu.png'),
                        height: 10,
                        width: 10),
                    const SizedBox(width: 5),
                    Text(
                      "View full menu",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 10.0,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'Lato'),
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

  Widget menuDialog(BuildContext context, List<Widget> columnChildren) {
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
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontSize: 12.0,
                            fontFamily: 'Lato',
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(
                      "Menu",
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 23.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: columnChildren,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
