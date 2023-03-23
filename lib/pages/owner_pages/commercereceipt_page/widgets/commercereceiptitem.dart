import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;

class CommerceReceiptItem extends StatefulWidget {
  final int quantity;
  final MenuItem menuItem;
  final StorageService clientStorage;
  const CommerceReceiptItem({
    Key? key,
    required this.quantity,
    required this.menuItem,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<CommerceReceiptItem> createState() => _CommerceReceiptItemState();
}

class _CommerceReceiptItemState extends State<CommerceReceiptItem> {
  // Create an instance variable.
  late final Future<ImageProvider<Object>?> _getPhoto;

  @override
  void initState() {
    super.initState();

    // Assign that variable your Future.
    _getPhoto = widget.clientStorage.getPhoto(widget.menuItem.itemImageRef);
  }

  @override
  Widget build(BuildContext context) {
    // Dietary processing
    List<Widget> pricingDietRowChildren = [
      Text(
        '\$${widget.menuItem.itemPrice}',
        style: dineTimeTypography.bodySmall?.copyWith(
          color: dineTimeColorScheme.primary,
        ),
      ),
      const SizedBox(width: 10.0),
    ];
    for (String diet in widget.menuItem.dietaryTags) {
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
    pricingDietRowChildren.add(const Spacer());
    pricingDietRowChildren.add(
      Container(
        width: 28,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dineTimeColorScheme.primary,
        ),
        child: Center(
          child: Text(
            widget.quantity.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
    pricingDietRowChildren.add(const SizedBox(width: 10.0));

    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: menuItemImage(context, 60.0),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.menuItem.itemName,
                    style: dineTimeTypography.headlineSmall,
                  ),
                  Row(
                    children: pricingDietRowChildren,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItemImage(BuildContext context, double size) {
    return Center(
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
