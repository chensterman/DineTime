import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/foodcard.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/pages/home/preorderreciept_page/preorderreciept.dart';

class PreorderRecieptDisplay extends StatelessWidget {
  const PreorderRecieptDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: PreorderReciept(
          itemPrice: 9.99,
          itemCount: 3,
          option: 'Small',
          specialInstructions: "No meat",
        ),
      ),
    );
  }
}
