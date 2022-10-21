import 'package:flutter/material.dart';

// Selector buttons for price tolerance
class PriceSelector extends StatelessWidget {
  final List<bool> isSelected;
  final List<Widget> children;
  final void Function(int)? onPressed;
  const PriceSelector({
    super.key,
    required this.isSelected,
    required this.children,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderColor: Theme.of(context).colorScheme.primary,
      selectedBorderColor: Theme.of(context).colorScheme.primary,
      selectedColor: Colors.white,
      fillColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.primary,
      isSelected: isSelected,
      children: children,
    );
  }
}
