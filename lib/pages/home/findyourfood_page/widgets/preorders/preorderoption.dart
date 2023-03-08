import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;

import 'preorderadditem.dart';

class PreorderOption extends StatefulWidget {
  final String itemName;
  final String itemDesc;
  final num price;
  final String itemImageRef;
  final List dietaryTags;
  final StorageService clientStorage;
  const PreorderOption({
    Key? key,
    required this.itemName,
    required this.itemDesc,
    required this.price,
    required this.itemImageRef,
    required this.dietaryTags,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<PreorderOption> createState() => _PreorderOptionState();
}

class _PreorderOptionState extends State<PreorderOption> {
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
    return InkWell(
      onTap: () {
        // Show a bottom sheet with the details of the selected menu item
        showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            context: context,
            builder: (context) => PreorderAddItem(
                  itemName: widget.itemName,
                  itemDesc: widget.itemDesc,
                  price: widget.price,
                  itemImageRef: widget.itemImageRef,
                  dietaryTags: widget.dietaryTags,
                  clientStorage: widget.clientStorage,
                ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.itemName,
                          softWrap: true,
                          style: dineTimeTypography.headlineSmall),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: pricingDietRowChildren,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.itemDesc,
                        style: dineTimeTypography.bodySmall?.copyWith(
                          color: dineTimeColorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30.0),
                menuItemImage(context, 75.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItemImage(BuildContext context, double size) {
    return Align(
      alignment: Alignment.topCenter,
      child: FutureBuilder(
        future: _getPhoto,
        builder: (context, AsyncSnapshot<ImageProvider<Object>?> snapshot) {
          if (snapshot.hasError) {
            return Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: const DecorationImage(
                    image: AssetImage("lib/assets/dinetime-orange.png"),
                    fit: BoxFit.cover,
                    opacity: 0.8),
              ),
            );
            // On success
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                    image: snapshot.data!, fit: BoxFit.cover, opacity: 0.8),
              ),
            );
            // On loading
          } else {
            return Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: dineTimeColorScheme.primary,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
