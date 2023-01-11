import 'package:flutter/material.dart';

// Cards that display list items in saved
class ListCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  const ListCard(
      {super.key,
      required this.child,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface, width: 1),
          borderRadius: BorderRadius.circular(15)),
      child: child,
    );
  }
}
