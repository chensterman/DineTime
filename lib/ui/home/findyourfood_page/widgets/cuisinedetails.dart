import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CuisineDetails extends StatelessWidget {
  final String cuisine;
  final int pricing;
  final Color color;
  const CuisineDetails({
    Key? key,
    required this.cuisine,
    required this.pricing,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontSize: 12.0,
                color: color,
                fontFamily: 'Lato',
              ),
          children: [
            TextSpan(text: cuisine),
            const TextSpan(
                text: '   ·   ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
            TextSpan(text: '\$' * pricing),
            const TextSpan(
                text: '   ·   ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
            const TextSpan(text: '2.2 mi'),
          ]),
    );
  }
}
