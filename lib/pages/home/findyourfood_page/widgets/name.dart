import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

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
      style: dineTimeTypography.headlineLarge?.copyWith(
        color: color,
      ),
    );
  }
}
