import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

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
          style: dineTimeTypography.headlineMedium,
        ),
        const SizedBox(height: 13),
        Text(
          restaurantBio,
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: dineTimeColorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
