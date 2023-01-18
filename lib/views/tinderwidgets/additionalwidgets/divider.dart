import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

class WidgetDivider extends StatelessWidget {
  const WidgetDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Color.fromARGB(95, 158, 158, 158), height: 1);
  }
}
