import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Filled button used across multiple forms
class ButtonFilled extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  const ButtonFilled({
    super.key,
    required this.text,
    required this.isDisabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Button styled with pimary colors on ElevatedButton class for filled effect
    ButtonStyle style = ElevatedButton.styleFrom(
        foregroundColor: dineTimeColorScheme.onPrimary,
        disabledBackgroundColor: dineTimeColorScheme.onSurface,
        disabledForegroundColor: dineTimeColorScheme.onPrimary,
        backgroundColor: dineTimeColorScheme.primary,
        textStyle: dineTimeTypography.headlineSmall,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize: const Size.fromHeight(50)); // 50 px height, inf width
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: style,
      child: Text(text),
    );
  }
}
