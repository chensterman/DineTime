import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

class FindYourFood extends StatefulWidget {
  const FindYourFood({Key? key}) : super(key: key);

  @override
  State<FindYourFood> createState() => _FindYourFoodState();
}

class _FindYourFoodState extends State<FindYourFood> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: RestaurantCard()));
  }
}
