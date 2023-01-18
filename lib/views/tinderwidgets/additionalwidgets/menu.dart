import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

class MenuOptions extends StatelessWidget {
  final String price;
  final String image;
  final String itemName;
  final String itemDesc;

  const MenuOptions({
    super.key,
    required this.price,
    required this.image,
    required this.itemName,
    required this.itemDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemName,
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 12.0,
                                    fontFamily: 'Lato',
                                  ),
                        ),
                        Text(
                          '\$' + price,
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(
                                  fontSize: 12.0,
                                  fontFamily: 'Lato',
                                  color: dineTimeColorScheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      itemDesc,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 8.0,
                            fontFamily: 'Lato',
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Container(
                  height: 60,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.5),
                    image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                        opacity: 0.8),
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
