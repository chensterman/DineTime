import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Bottom navigation bar
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
      color: dineTimeColorScheme.onPrimary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.25),
        child: BottomNavigationBar(
          iconSize: 32.0,
          items: items,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          backgroundColor: dineTimeColorScheme.onPrimary,
          selectedItemColor: dineTimeColorScheme.primary,
          unselectedItemColor: dineTimeColorScheme.onSurface,
          selectedLabelStyle: dineTimeTypography.bodySmall,
          unselectedLabelStyle: dineTimeTypography.bodySmall,
          onTap: onTap,
        ),
      ),
    );
  }
}
