import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CuisineDetails extends StatelessWidget {
  final String cuisine;
  final int pricing;
  final num? distance;
  final Color color;
  const CuisineDetails({
    Key? key,
    required this.cuisine,
    required this.pricing,
    required this.distance,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String infoText = distance != null
        ? '$cuisine  ·  ${'\$' * pricing}  ·  $distance mi'
        : '$cuisine  ·  ${'\$' * pricing}';
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontSize: 12.0,
                color: color,
                fontFamily: 'Lato',
              ),
          children: [
            TextSpan(text: infoText),
          ]),
    );
  }
}
