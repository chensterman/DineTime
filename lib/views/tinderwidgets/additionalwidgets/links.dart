import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class Links extends StatelessWidget {
  const Links({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Link(
          uri: Uri.parse('instagram.com'),
          builder: (context, followLink) => SizedBox(
            width: 52,
            height: 35,
            child: ElevatedButton(
              onPressed: followLink,
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), elevation: 0.8),
              child: Image.asset(
                'lib/assets/orange_instagram.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
        Link(
          uri: Uri.parse('instagram.com'),
          builder: (context, followLink) => SizedBox(
            width: 52,
            height: 35,
            child: ElevatedButton(
              onPressed: followLink,
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), elevation: 0.8),
              child: Image.asset(
                'lib/assets/world2.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        Link(
          uri: Uri.parse('instagram.com'),
          builder: (context, followLink) => SizedBox(
            width: 52,
            height: 35,
            child: ElevatedButton(
              onPressed: followLink,
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), elevation: 0.8),
              child: Image.asset(
                'lib/assets/email.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        const Spacer(),
        Image.asset(
          'lib/assets/link.png',
          width: 20,
          height: 20,
        ),
      ],
    );
  }
}
