import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

class Logo extends StatelessWidget {
  final String logopath;

  const Logo({
    super.key,
    required this.logopath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: dineTimeColorScheme.primary, width: 4),
      ),
      child: ClipOval(
        child: Image.asset(logopath),
      ),
    );
  }
}
