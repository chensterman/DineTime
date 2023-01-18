import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

class Name extends StatelessWidget {
  final String name;

  const Name({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 28.0,
            color: dineTimeColorScheme.background,
            fontFamily: 'Lato',
          ),
    );
  }
}
