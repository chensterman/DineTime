import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;

class MenuOption extends StatefulWidget {
  final String itemName;
  final String itemDesc;
  final num price;
  final String itemImageRef;
  final List dietaryTags;
  final StorageService clientStorage;
  final double paddingValue;
  const MenuOption({
    Key? key,
    required this.itemName,
    required this.itemDesc,
    required this.price,
    required this.itemImageRef,
    required this.dietaryTags,
    required this.clientStorage,
    required this.paddingValue,
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
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => menuItemDialog(context),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(widget.paddingValue),
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

  Widget menuItemDialog(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 25.0),
            Text(
              widget.itemName,
              style: dineTimeTypography.headlineMedium,
            ),
            const SizedBox(height: 20.0),
            menuItemImage(context, 300.0),
            const SizedBox(height: 20.0),
            Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      widget.itemDesc,
                      style: dineTimeTypography.bodyMedium?.copyWith(
                        color: dineTimeColorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
