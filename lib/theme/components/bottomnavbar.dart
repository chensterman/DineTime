import 'package:flutter/material.dart';

// Bottom navigation bar.
class BottomNavBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final Function(int)? onTap;
  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get size of screen
    double width = MediaQuery.of(context).size.width;
    // Container to add padding and reduce spacing between nav bar items
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.25),
        child: BottomNavigationBar(
          items: items,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface,
          selectedLabelStyle:
              Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12.0),
          unselectedLabelStyle:
              Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12.0),
          onTap: onTap,
        ),
      ),
    );
  }
}
