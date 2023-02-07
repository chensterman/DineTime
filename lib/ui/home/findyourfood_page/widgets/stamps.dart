import 'package:dinetime_mobile_mvp/provider/cardprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Stamps extends StatelessWidget {
  const Stamps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = stamp(
          color: Colors.green,
          text: 'lib/assets/like_logo.png',
          opacity: opacity,
        );

        return Positioned(top: 200, left: -100, child: child);
      case CardStatus.dislike:
        final child = stamp(
          color: Colors.red,
          text: 'lib/assets/dislike_logo.png',
          opacity: opacity,
        );

        return Positioned(top: 200, right: -100, child: child);
      default:
        return Container();
    }
  }

  Widget stamp({
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: const RadialGradient(
                colors: [
                  Color.fromARGB(200, 255, 255, 255),
                  Colors.transparent,
                ],
                stops: [0.5, 1],
              ),
            ),
          ),
          Image.asset(text, height: 70, width: 70),
        ],
      ),
    );
  }
}
