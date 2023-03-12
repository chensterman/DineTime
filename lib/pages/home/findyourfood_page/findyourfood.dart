import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/findyourfood_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/preorderbag/preorderbag_bloc.dart';

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
