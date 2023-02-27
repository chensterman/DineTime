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
        style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 14.0,
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
          padding: EdgeInsets.all(widget.paddingValue),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itemName,
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
                      children: pricingDietRowChildren,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      child: Text(
                        widget.itemDesc,
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
