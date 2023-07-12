import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/fooddisplay_page/fooddisplay.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';

import '../../models/restaurant.dart';

class BusinessById extends StatefulWidget {
  final String restaurantId;
  final Services services;
  final UserDT user;
  const BusinessById({
    Key? key,
    required this.restaurantId,
    required this.services,
    required this.user,
  }) : super(key: key);

  @override
  State<BusinessById> createState() => _BusinessByIdState();
}

class _BusinessByIdState extends State<BusinessById> {
  Future<Map> _getData() async {
    Restaurant? restaurant =
        await widget.services.clientDB.restaurantGet(widget.restaurantId);
    print(restaurant);
    Customer? customer =
        await widget.services.clientDB.customerGet(widget.user.uid);
    return {
      "restaurant": restaurant,
      "customer": customer,
    };
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: _getData(),
      builder: ((context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
          // On success
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map data = snapshot.data!;
          if (data["customer"] == null) {
            return const Text("Cannot retrieve user");
          }
          return FoodDisplay(
            customer: data["customer"]!,
            restaurant: data["restaurant"]!,
            origin: "",
          );
          // On loading
        } else {
          return const LogoDisplay(
            width: 40.0,
            height: 40.0,
            isLoading: true,
          );
        }
      }),
    );
  }
}
