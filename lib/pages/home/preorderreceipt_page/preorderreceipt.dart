import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/preorderreceipt_page/preorderreceiptdisplay.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class PreorderReceipt extends StatelessWidget {
  final Customer customer;
  final PreorderBag preorderBag;
  const PreorderReceipt({
    super.key,
    required this.customer,
    required this.preorderBag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: dineTimeColorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: dineTimeColorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: PreorderReceiptDisplay(
          customer: customer,
          preorderBag: preorderBag,
        ),
      ),
    );
  }
}
