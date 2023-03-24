import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'findyourfood_layout.dart';
import 'package:flutter/material.dart';

class FindYourFood extends StatelessWidget {
  final Customer customer;
  const FindYourFood({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return FindYourFoodLayout(customer: customer);
  }
}
