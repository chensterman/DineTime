import 'package:flutter/material.dart';

class PreorderButton extends StatelessWidget {
  final double fromTop;
  const PreorderButton({
    Key? key,
    required this.fromTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Button styled with pimary colors on ElevatedButton class for filled effect
    ButtonStyle style = ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        disabledBackgroundColor: Theme.of(context).colorScheme.onSurface,
        disabledForegroundColor: const Color(0xFFFFA869),
        backgroundColor: Theme.of(context).colorScheme.primary,
        textStyle: Theme.of(context).textTheme.button,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize: const Size.fromHeight(50)); // 50 px height, inf width
    return Positioned(
      bottom: 20.0,
      child: SizedBox(
        width: 150.0,
        child: ElevatedButton(
          onPressed: () {},
          style: style,
          child: const Text("Pre-Order"),
        ),
      ),
    );
  }
}
