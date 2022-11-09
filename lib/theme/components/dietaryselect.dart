import 'package:flutter/material.dart';

class DietaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  const DietaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  State<DietaryButton> createState() => _DietaryButtonState();
}

class _DietaryButtonState extends State<DietaryButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    // Button styled with pimary colors on ElevatedButton class for filled effect
    ButtonStyle style = ElevatedButton.styleFrom(
      foregroundColor: selected
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onBackground,
      backgroundColor: selected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimary,
      textStyle: Theme.of(context).textTheme.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      minimumSize: const Size(30.0, 40.0),
    );
    return ElevatedButton(
      onPressed: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
        setState(() {
          selected = !selected;
        });
      },
      style: style,
      child: Text(widget.text),
    );
  }
}
