import 'dart:ffi';

import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/menuoption.dart';

class Preorders extends StatelessWidget {
  final List<r.MenuItem> menu;
  const Preorders({
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
        paddingValue: 0.0,
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
        preorderMainButton(context),
      ],
    );
  }

  Widget preorderMainButton(BuildContext context) {
    Services services = Provider.of<Services>(context);
    List<Widget> columnChildren = [];
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: dineTimeColorScheme.onPrimary,
      disabledBackgroundColor: dineTimeColorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: dineTimeColorScheme.primary,
      textStyle: dineTimeTypography.bodySmall?.copyWith(
        color: dineTimeColorScheme.background,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ); // 50 px height, inf width
    for (r.MenuItem menuItem in menu) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(
        InkWell(
          onTap: () {
            // Show a bottom sheet with the details of the selected menu item
            showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              context: context,
              builder: (context) => Stack(
                alignment: Alignment.center,
                children: [
                  ItemDescription(
                    itemName: menuItem.itemName,
                    itemDesc: menuItem.itemDescription,
                    price: menuItem.itemPrice,
                    itemImageRef: menuItem.itemImageRef,
                    dietaryTags: menuItem.dietaryTags,
                    clientStorage: services.clientStorage,
                  ),
                  AddItemsBag(),
                ],
              ),
            );
          },
          child: MenuOption(
            itemName: menuItem.itemName,
            itemDesc: menuItem.itemDescription,
            price: menuItem.itemPrice,
            itemImageRef: menuItem.itemImageRef,
            dietaryTags: menuItem.dietaryTags,
            clientStorage: services.clientStorage,
            paddingValue: 0.0,
          ),
        ),
      );
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
    return Positioned(
      bottom: 40.0,
      child: SizedBox(
        width: 130,
        height: 40,
        child: Opacity(
          opacity: 0.8,
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
                  children: [
                    preorderMenu(context, columnChildren),
                    viewPreorderButton(context),
                  ],
                ),
              );
            },
            style: style,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/preorderfork.png',
                  width: 14,
                  height: 14,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Pre-Order",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget viewPreorderButton(BuildContext context) {
    Services services = Provider.of<Services>(context);
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
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                builder: (context) {
                  return Material(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text('Mock Pre-Order Page'),
                    ),
                  );
                },
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
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontSize: 12.0,
                            fontFamily: 'Lato',
                            color: dineTimeColorScheme.primary),
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
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
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
}

class ItemDescription extends StatefulWidget {
  final String itemName;
  final String itemDesc;
  final num price;
  final String itemImageRef;
  final List dietaryTags;
  final StorageService clientStorage;
  const ItemDescription({
    Key? key,
    required this.itemName,
    required this.itemDesc,
    required this.price,
    required this.itemImageRef,
    required this.dietaryTags,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<ItemDescription> createState() => _ItemDescriptionState();
}

class _ItemDescriptionState extends State<ItemDescription> {
  late final Future<ImageProvider<Object>?> _getPhoto;
  int _counter = 0;
  int? _selectedOptionIndex;

  @override
  void initState() {
    super.initState();

    // Assign that variable your Future.
    _getPhoto = widget.clientStorage.getPhoto(widget.itemImageRef);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> sizeOptions = [
      'Small (12 oz.)',
      'Large (18 oz.)',
      'Extra Large (20 oz.)',
    ];
    List<Widget> pricingDietRowChildren = [
      Text(
        '\$${widget.price}',
        style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 20.0,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500),
      ),
      const SizedBox(width: 10.0),
    ];

    for (String diet in widget.dietaryTags) {
      String imagePath = r.dietToImagePath[diet]!;
      pricingDietRowChildren.add(
        Image.asset(
          imagePath,
          width: 20,
          height: 20,
        ),
      );
      pricingDietRowChildren.add(const SizedBox(width: 10.0));
    }
    pricingDietRowChildren.add(Spacer());
    // Add the add subtract button to the pricingDietRowChildren list
    pricingDietRowChildren.addAll([
      SizedBox(
        height: 28,
        child: Row(
          children: [
            InkWell(
              onTap: _decrementCounter,
              child: Container(
                width: 28,
                height: 30,
                decoration: BoxDecoration(
                  color: dineTimeColorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 30,
              decoration: BoxDecoration(
                color: dineTimeColorScheme.primary,
              ),
              child: Center(
                child: Text(
                  '$_counter',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: _incrementCounter,
              child: Container(
                width: 28,
                height: 30,
                decoration: BoxDecoration(
                  color: dineTimeColorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.84,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        builder: (_, controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: _getPhoto,
                    builder: (context,
                        AsyncSnapshot<ImageProvider<Object>?> snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
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
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
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
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
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
                Positioned(
                  top: 10.0,
                  left: 10.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName,
                        softWrap: true,
                        textAlign: TextAlign.start, // align text to the left
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: pricingDietRowChildren,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        child: Text(
                          widget.itemDesc,
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontSize: 12.0,
                                    fontFamily: 'Lato',
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(),
                      const SizedBox(height: 10.0),
                      Text(
                        "Select a Size",
                        softWrap: true,
                        textAlign: TextAlign.start, // align text to the left
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Column(
                        children: List<Widget>.generate(
                          sizeOptions.length,
                          (index) {
                            return RadioListTile(
                              title: Text(
                                sizeOptions[index],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              value: index,
                              activeColor: Colors.black,
                              groupValue: _selectedOptionIndex,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOptionIndex = value as int;
                                });
                              },
                              selected: true,
                              contentPadding: EdgeInsets.zero,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(),
                      const SizedBox(height: 10.0),
                      Text(
                        "Special Instructions",
                        softWrap: true,
                        textAlign: TextAlign.start, // align text to the left
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        height: 250,
                        child: TextField(
                          controller: TextEditingController(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'Less spicy, no meat',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.all(10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          minLines: 6, // Set the minimum number of lines to 5
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddItemsBag extends StatefulWidget {
  final Double? itemPrice;
  final int? itemCount;
  final String? option;
  final String? specialInstructions;
  const AddItemsBag({
    Key? key,
    this.itemPrice,
    this.itemCount,
    this.option,
    this.specialInstructions,
  }) : super(key: key);

  @override
  State<AddItemsBag> createState() => _AddItemsBagState();
}

class _AddItemsBagState extends State<AddItemsBag> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
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
                  "Add Items to Bag",
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

class MenuItem {
  final String itemName;
  final String itemDesc;
  final num price;
  final String itemImageRef;
  final List<String> dietaryTags;
  int count;
  String? specialInstructions;
  String? radioListTileChoice;

  MenuItem({
    required this.itemName,
    required this.itemDesc,
    required this.price,
    required this.itemImageRef,
    required this.dietaryTags,
    this.count = 0,
    this.specialInstructions,
    this.radioListTileChoice,
  });
}
