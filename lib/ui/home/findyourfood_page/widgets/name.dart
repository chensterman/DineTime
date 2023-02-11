import 'package:flutter/material.dart';

class Name extends StatelessWidget {
  final String restaurantName;
  final Color color;
  const Name({
    Key? key,
    required this.restaurantName,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      restaurantName,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 25.0,
            color: color,
            fontWeight: FontWeight.normal,
          ),
    );
  }
}
