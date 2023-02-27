import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Progress bar indicator
class ProgressBar extends StatelessWidget {
  final double percentCompletion; // On scale 0.0 - 1.0
  const ProgressBar({
    super.key,
    required this.percentCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: dineTimeColorScheme.onSurface,
      color: dineTimeColorScheme.primary,
      value: percentCompletion,
    );
  }
}
