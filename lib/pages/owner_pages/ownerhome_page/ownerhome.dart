import 'package:dinetime_mobile_mvp/models/owner.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/owner_pages/commerce_page/commerce.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class OwnerHome extends StatefulWidget {
  final Services services;
  final UserDT user;
  const OwnerHome({
    Key? key,
    required this.services,
    required this.user,
  }) : super(key: key);

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  int _selectedIndex = 0;

  // Update selected index for BottomNavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.services.clientDB.ownerAddToken(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.services.clientDB.ownerGet(widget.user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          Owner owner = snapshot.data!;

          // // Widget list for bottom nav bar
          // final List<Widget> pages = <Widget>[
          //   Commerce(
          //     restaurant: owner.restaurants[0],
          //   ),
          // ];

          return Scaffold(
            extendBodyBehindAppBar: false,
            body: Commerce(restaurant: owner.restaurants[0]),
            // body: _selectedIndex == 0
            //     ? pages.elementAt(_selectedIndex)
            //     : Padding(
            //         padding: const EdgeInsets.only(top: 45),
            //         child: pages.elementAt(_selectedIndex)),
            // bottomNavigationBar: BottomNavBar(
            //   currentIndex: _selectedIndex,
            //   onTap: _onItemTapped,
            //   items: const [
            //     BottomNavigationBarItem(
            //       icon: Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 8.0),
            //         child: Icon(Icons.shopping_cart_checkout_rounded),
            //       ),
            //       label: 'Orders',
            //     ),
            //   ],
            // ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
