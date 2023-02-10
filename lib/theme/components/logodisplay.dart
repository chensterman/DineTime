import 'package:flutter/material.dart';

class LogoDisplay extends StatelessWidget {
  final ImageProvider image;
  const LogoDisplay({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
        ),
        shape: BoxShape.circle,
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
      ),
    );
  }
}
