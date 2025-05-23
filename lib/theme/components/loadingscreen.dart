import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(context) {
    // Loading screen
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: dineTimeColorScheme.primary,
        ),
      ),
    );
  }
}
