import 'package:flutter/material.dart';

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
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      color: Theme.of(context).colorScheme.primary,
      value: percentCompletion,
    );
  }
}
