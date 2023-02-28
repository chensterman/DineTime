import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

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
      borderColor: dineTimeColorScheme.primary,
      selectedBorderColor: dineTimeColorScheme.primary,
      selectedColor: Colors.white,
      fillColor: dineTimeColorScheme.primary,
      color: dineTimeColorScheme.primary,
      isSelected: isSelected,
      children: children,
    );
  }
}
