import 'dart:async';

import 'package:dinetime_mobile_mvp/pages/root/routing_page/routing.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

// Start page with a 5 second viewing of the DineTime logo
class Start extends StatelessWidget {
  const Start({
    super.key,
  });

  @override
  Widget build(context) {
    // Timer to display DineTime logo before routing to AuthStateCheck
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const Routing(),
          ),
        );
      },
    );
    // DineTime logo displayed
    return Scaffold(
      backgroundColor: dineTimeColorScheme.primary,
      body: const Padding(
        padding: EdgeInsets.all(96.0),
        child: Center(
          child: Image(
            width: 200.0,
            height: 200.0,
            image: AssetImage('lib/assets/dinetime-combo-white.png'),
          ),
        ),
      ),
    );
  }
}
