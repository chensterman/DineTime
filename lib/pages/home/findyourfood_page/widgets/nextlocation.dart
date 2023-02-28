import 'package:dinetime_mobile_mvp/theme/typography.dart';
import 'package:flutter/material.dart';

class NextLocation extends StatelessWidget {
  final String locationName;
  final String imagePath;
  final Color color;
  const NextLocation({
    Key? key,
    required this.locationName,
    required this.imagePath,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 10.5),
        Text(
          locationName,
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
