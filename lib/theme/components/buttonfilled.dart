import 'package:flutter/material.dart';

// Filled button used across multiple forms
class ButtonFilled extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const ButtonFilled({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Button styled with pimary colors on ElevatedButton class for filled effect
    ButtonStyle style = ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textStyle: Theme.of(context).textTheme.button,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize: const Size.fromHeight(50)); // 50 px height, inf width
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(text),
    );
  }
}
