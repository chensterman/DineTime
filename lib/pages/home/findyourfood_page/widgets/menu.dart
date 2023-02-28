import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:provider/provider.dart';

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
    num count = 0;
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
              style: dineTimeTypography.headlineMedium,
            ),
            menu.isEmpty
                ? Text(
                    'No menu items.',
                    style: dineTimeTypography.bodyMedium?.copyWith(
                      color: dineTimeColorScheme.onSurface,
                    ),
                  )
                : Container(),
            menuButton(context),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: dineTimeColorScheme.onSurface, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          ),
        ),
      ],
    );
  }

  Widget menuButton(BuildContext context) {
    Services services = Provider.of<Services>(context);
    List<Widget> columnChildren = [];
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(MenuOption(
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
              color: dineTimeColorScheme.primary.withOpacity(0.2),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('lib/assets/view_menu.png'),
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "View full menu",
                      style: dineTimeTypography.bodySmall?.copyWith(
                        color: dineTimeColorScheme.primary,
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
                        style: dineTimeTypography.bodySmall?.copyWith(
                          color: dineTimeColorScheme.primary,
                        ),
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
                      style: dineTimeTypography.headlineSmall,
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

class MenuOption extends StatefulWidget {
  final String itemName;
  final String itemDesc;
  final num price;
  final String itemImageRef;
  final List dietaryTags;
  final StorageService clientStorage;
  const MenuOption({
    Key? key,
    required this.itemName,
    required this.itemDesc,
    required this.price,
    required this.itemImageRef,
    required this.dietaryTags,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<MenuOption> createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
  // Create an instance variable.
  late final Future<ImageProvider<Object>?> _getPhoto;

  @override
  void initState() {
    super.initState();

    // Assign that variable your Future.
    _getPhoto = widget.clientStorage.getPhoto(widget.itemImageRef);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pricingDietRowChildren = [
      Text(
        '\$${widget.price}',
        style: dineTimeTypography.bodySmall?.copyWith(
          color: dineTimeColorScheme.primary,
        ),
      ),
      const SizedBox(width: 10.0),
    ];
    for (String diet in widget.dietaryTags) {
      String imagePath = r.dietToImagePath[diet]!;
      pricingDietRowChildren.add(
        Image.asset(
          imagePath,
          width: 15,
          height: 15,
        ),
      );
      pricingDietRowChildren.add(const SizedBox(width: 10.0));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itemName,
                      softWrap: true,
                      style: dineTimeTypography.headlineSmall,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: pricingDietRowChildren,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      child: Text(
                        widget.itemDesc,
                        style: dineTimeTypography.bodySmall?.copyWith(
                          color: dineTimeColorScheme.onSurface,
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
                  padding: const EdgeInsets.only(left: 30.0),
                  child: FutureBuilder(
                    future: _getPhoto,
                    builder: (context,
                        AsyncSnapshot<ImageProvider<Object>?> snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.5),
                            image: const DecorationImage(
                                image: AssetImage(
                                    "lib/assets/dinetime-orange.png"),
                                fit: BoxFit.cover,
                                opacity: 0.8),
                          ),
                        );
                        // On success
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.5),
                            image: DecorationImage(
                                image: snapshot.data!,
                                fit: BoxFit.cover,
                                opacity: 0.8),
                          ),
                        );
                        // On loading
                      } else {
                        return Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
