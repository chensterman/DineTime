import 'dart:async';
import 'package:dinetime_mobile_mvp/views/signin.dart';
import 'package:flutter/material.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(context) {
    Timer(
        const Duration(seconds: 5),
        () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              )
            });
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: const Center(
          child: Image(
            image: AssetImage('lib/assets/dinetime-combo-white.png'),
          ),
        ));
  }
}
