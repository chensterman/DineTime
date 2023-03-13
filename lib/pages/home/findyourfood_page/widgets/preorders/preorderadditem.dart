import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/blocs/preorderbag/preorderbag_bloc.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class PreorderAddItem extends StatefulWidget {
  final MenuItem menuItem;
  final int initialQuantity;
  final StorageService clientStorage;
  final PreorderBagBloc preorderBagBloc;
  const PreorderAddItem({
    Key? key,
    required this.menuItem,
    required this.initialQuantity,
    required this.clientStorage,
    required this.preorderBagBloc,
  }) : super(key: key);

  @override
  State<PreorderAddItem> createState() => _PreorderAddItemState();
}

class _PreorderAddItemState extends State<PreorderAddItem> {
  int _quantity = 0;
  late final Future<ImageProvider<Object>?> _getPhoto;
  // int? _selectedOptionIndex;

  @override
  void initState() {
    super.initState();

    _quantity = widget.initialQuantity;

    // Assign that variable your Future.
    _getPhoto = widget.clientStorage.getPhoto(widget.menuItem.itemImageRef);
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final List<String> sizeOptions = [
    //   'Small (12 oz.)',
    //   'Large (18 oz.)',
    //   'Extra Large (20 oz.)',
    // ];
    List<Widget> pricingDietRowChildren = [
      Text(
        '\$${widget.menuItem.itemPrice}',
        style: dineTimeTypography.headlineMedium?.copyWith(
          color: dineTimeColorScheme.primary,
        ),
      ),
      const SizedBox(width: 10.0),
    ];

    for (String diet in widget.menuItem.dietaryTags) {
      String imagePath = dietToImagePath[diet]!;
      pricingDietRowChildren.add(
        Image.asset(
          imagePath,
          width: 20,
          height: 20,
        ),
      );
      pricingDietRowChildren.add(const SizedBox(width: 10.0));
    }
    pricingDietRowChildren.add(const Spacer());
    // Add the add subtract button to the pricingDietRowChildren list
    pricingDietRowChildren.addAll(
      [
        SizedBox(
          height: 28,
          child: Row(
            children: [
              InkWell(
                onTap: _decrement,
                child: Container(
                  width: 28,
                  height: 30,
                  decoration: BoxDecoration(
                    color: dineTimeColorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: const Icon(
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
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: _increment,
                child: Container(
                  width: 28,
                  height: 30,
                  decoration: BoxDecoration(
                    color: dineTimeColorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      expand: false,
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
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          color: Colors.white.withOpacity(0.5),
                          image: const DecorationImage(
                              image:
                                  AssetImage("lib/assets/dinetime-orange.png"),
                              fit: BoxFit.cover,
                              opacity: 0.8),
                        ),
                      );
                      // On success
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
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
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
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
                      icon: const Icon(Icons.close),
                      color: dineTimeColorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.menuItem.itemName,
                      softWrap: true,
                      textAlign: TextAlign.start, // align text to the left
                      style: dineTimeTypography.headlineMedium,
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
                    Text(
                      widget.menuItem.itemDescription,
                      style: dineTimeTypography.bodyMedium?.copyWith(
                        color: dineTimeColorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    // const SizedBox(height: 10.0),
                    // const Divider(),
                    // const SizedBox(height: 10.0),
                    // Text(
                    //   "Select a Size",
                    //   softWrap: true,
                    //   textAlign: TextAlign.start, // align text to the left
                    //   style: ,
                    // ),
                    // Column(
                    //   children: List<Widget>.generate(
                    //     sizeOptions.length,
                    //     (index) {
                    //       return RadioListTile(
                    //         title: Text(
                    //           sizeOptions[index],
                    //           style: TextStyle(
                    //               fontSize: 14, color: Colors.black),
                    //         ),
                    //         value: index,
                    //         activeColor: Colors.black,
                    //         groupValue: _selectedOptionIndex,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _selectedOptionIndex = value as int;
                    //           });
                    //         },
                    //         selected: true,
                    //         contentPadding: EdgeInsets.zero,
                    //       );
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(height: 10.0),
                    // const Divider(),
                    // const SizedBox(height: 10.0),
                    // Text(
                    //   "Special Instructions",
                    //   softWrap: true,
                    //   textAlign: TextAlign.start, // align text to the left
                    //   style: Theme.of(context).textTheme.headline1?.copyWith(
                    //         fontSize: 25.0,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    // ),
                    // const SizedBox(height: 20.0),
                    // Container(
                    //   height: 250,
                    //   child: TextField(
                    //     controller: TextEditingController(),
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 14,
                    //     ),
                    //     cursorColor: Colors.black,
                    //     decoration: InputDecoration(
                    //       hintText: 'Less spicy, no meat',
                    //       hintStyle: TextStyle(
                    //         fontSize: 14,
                    //         color: Colors.grey,
                    //       ),
                    //       contentPadding: EdgeInsets.all(10),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       focusedErrorBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //     minLines: 6, // Set the minimum number of lines to 5
                    //     maxLines: null,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25.0),
          addItemButton(),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }

  Widget addItemButton() {
    // Button styled with pimary colors on ElevatedButton class for filled effect
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: dineTimeColorScheme.onPrimary,
      disabledBackgroundColor: dineTimeColorScheme.onSurface,
      disabledForegroundColor: dineTimeColorScheme.primary,
      backgroundColor: dineTimeColorScheme.primary,
      textStyle: dineTimeTypography.headlineSmall?.copyWith(
        color: dineTimeColorScheme.onPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ); // 50 px height, inf width
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        height: 40,
        child: Opacity(
          opacity: 0.9,
          child: ElevatedButton(
            onPressed: () {
              widget.preorderBagBloc.add(PreorderBagUpdate(
                  preorderItem: PreorderItem(
                      item: widget.menuItem, quantity: _quantity)));
              Navigator.pop(context);
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
                  "Add / Update Bag Item",
                  style: dineTimeTypography.bodySmall?.copyWith(
                    color: dineTimeColorScheme.onPrimary,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Container(
                  width: 25.0,
                  height: 25.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _quantity.toString(),
                      style: dineTimeTypography.bodySmall?.copyWith(
                        color: dineTimeColorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "\$${widget.menuItem.itemPrice * _quantity}",
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
