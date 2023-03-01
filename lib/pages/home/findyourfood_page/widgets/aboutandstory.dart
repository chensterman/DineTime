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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Our Story',
              style: dineTimeTypography.headlineMedium,
            ),
            expandButton(context),
          ],
        ),
        const SizedBox(height: 13),
        Text(
          restaurantBio,
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: dineTimeColorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget expandButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => aboutDialog(context),
        );
      },
      child: Image.asset(
        "lib/assets/expanded.png",
        height: 30,
        width: 30,
      ),
    );
  }

  Widget aboutDialog(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    const Image(
                        image: AssetImage('lib/assets/back_arrow.png'),
                        height: 12,
                        width: 12),
                    const SizedBox(width: 10),
                    Text(
                      "Go Back",
                      style: dineTimeTypography.bodySmall?.copyWith(
                        color: dineTimeColorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Our Story',
                style: dineTimeTypography.headlineMedium,
              ),
            ),
            const SizedBox(height: 10.0),
            Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      restaurantBio,
                      style: dineTimeTypography.bodyMedium?.copyWith(
                        color: dineTimeColorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
