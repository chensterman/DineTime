import 'package:flutter/material.dart';

class AboutandStory extends StatelessWidget {
  final String about;

  const AboutandStory({
    super.key,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About & Story',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        const SizedBox(height: 10),
        Text(
          about,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                fontSize: 12.0,
                fontFamily: 'Lato',
              ),
        ),
      ],
    );
  }
}
