import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/customerhome_page/customerhome.dart';
import 'package:dinetime_mobile_mvp/pages/owner_pages/ownerhome_page/ownerhome.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final UserDT user;
  final Services services;
  const Home({
    Key? key,
    required this.user,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Main page widget (contains nav bar pages as well)
    return user.isCustomer
        ? CustomerHome(services: services, user: user)
        : OwnerHome(services: services, user: user);
  }
}
