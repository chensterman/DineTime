import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/provider/card_provider.dart';

class Refresh extends StatelessWidget {
  const Refresh({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 50,
            height: 50,
            child: InkWell(
              onTap: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);

                provider.resetUsers();
              },
              child: Image.asset(
                'lib/assets/reload.png',
                width: 200,
                height: 50,
              ),
            )),
      ],
    );
  }
}
