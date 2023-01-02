import 'package:url_launcher/link.dart';
import 'package:flutter/material.dart';

class mediaCircle extends StatelessWidget {
  final String image;
  final String url;

  mediaCircle({
    required this.image,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      builder: (context, followLink) => ElevatedButton(
        onPressed: followLink,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Image.asset(
            image,
            width: 10,
            height: 10,
          ),
        ),
      ),
    );
  }
}
