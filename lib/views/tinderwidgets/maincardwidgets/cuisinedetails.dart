import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

class CuisineDetails extends StatelessWidget {
  final String cuisine;
  final String cost;
  final String distance;

  const CuisineDetails({
    super.key,
    required this.cuisine,
    required this.cost,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontSize: 12.0,
              color: dineTimeColorScheme.background,
              fontFamily: 'Lato'),
          children: [
            TextSpan(text: cuisine),
            const TextSpan(
                text: '   ·   ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: cost),
            const TextSpan(
                text: '   ·   ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: distance),
          ]),
    );
  }
}
