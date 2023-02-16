// The base widget for the app using the MatieralApp class
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/material.dart';

class PageTestBase extends StatelessWidget {
  final Widget page;
  const PageTestBase({
    super.key,
    required this.page,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DineTime Demo',
      theme: ThemeData(
        colorScheme: dineTimeColorScheme,
        textTheme: dineTimeTypography,
      ),
      home: page,
    );
  }
}
