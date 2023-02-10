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
          width: 13,
          height: 13,
        ),
        const SizedBox(width: 10.5),
        Text(
          locationName,
          style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 12.0,
              color: color,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
