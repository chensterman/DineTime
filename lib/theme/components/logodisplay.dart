import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class LogoDisplay extends StatelessWidget {
  final double width;
  final double height;
  final ImageProvider? image;
  final bool isLoading;
  const LogoDisplay({
    Key? key,
    required this.width,
    required this.height,
    this.image,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: isLoading
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: image!,
              ),
        shape: BoxShape.circle,
        border: Border.all(color: dineTimeColorScheme.primary, width: 3),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(),
    );
  }
}
