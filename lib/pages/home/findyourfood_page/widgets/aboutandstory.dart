import 'package:flutter/material.dart';

class AboutAndStory extends StatelessWidget {
  final String restaurantBio;
  const AboutAndStory({
    Key? key,
    required this.restaurantBio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Story',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 13),
        Text(
          restaurantBio,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                fontSize: 12.0,
                fontFamily: 'Lato',
              ),
        ),
      ],
    );
  }
}
