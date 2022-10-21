import 'package:flutter/material.dart';

// Outlined button used across multiple forms.
class ButtonOutlined extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const ButtonOutlined({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Button styled with pimary colors on OutlinedButton class for outlined effect
    ButtonStyle style = OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // Outlined border
      side: BorderSide(
        width: 1.0,
        color: Theme.of(context).colorScheme.primary,
        style: BorderStyle.solid,
      ),
      textStyle: Theme.of(context).textTheme.button,
      minimumSize: const Size.fromHeight(50), // 50 px height, inf width
    );
    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: Text(text),
    );
  }
}
