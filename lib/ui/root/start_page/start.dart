import 'dart:async';

import 'package:dinetime_mobile_mvp/ui/root/routing_page/routing.dart';
import 'package:flutter/material.dart';

// Start page with a 5 second viewing of the DineTime logo
class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(context) {
    // Timer to display DineTime logo before routing to AuthStateCheck
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Routing()));
      },
    );
    // DineTime logo displayed
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Image(
          image: AssetImage('lib/assets/dinetime-combo-white.png'),
        ),
      ),
    );
  }
}
