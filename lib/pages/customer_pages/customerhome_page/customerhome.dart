import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/owner_pages/commerce_page/commerce.dart';
import 'package:dinetime_mobile_mvp/pages/home/events/event_page.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/findyourfood_page/findyourfood.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/preorders_page/preorders.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/favorites_page/favorites.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/search_page/search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class CustomerHome extends StatefulWidget {
  final Services services;
  final UserDT user;
  const CustomerHome({
    Key? key,
    required this.services,
    required this.user,
  }) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _selectedIndex = 0;

  // Update selected index for BottomNavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get user location, update the user data, and create address
  Future<void> _updateUserLocation() async {
    String customerId = widget.services.clientAuth.getCurrentUserUid()!;
    GeoPoint? userLocation =
        await widget.services.clientLocation.getLocationData();
    await widget.services.clientDB.customerUpdate(customerId, {
      'geolocation': userLocation,
    });
  }

  Future<void> _updateUserToken() async {
    String customerId = widget.services.clientAuth.getCurrentUserUid()!;
    await widget.services.clientDB.customerAddToken(customerId);
  }

  @override
  void initState() {
    super.initState();
    widget.services.clientNotifications.handleNotifications();
    widget.services.clientNotifications.handleToken();
    _updateUserLocation();
    _updateUserToken();
    // _handleNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.services.clientDB.customerGet(widget.user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          Customer customer = snapshot.data!;

          // Widget list for bottom nav bar
          final List<Widget> pages = <Widget>[
            FindYourFood(
              customer: customer,
            ),
            Favorites(
              customer: customer,
            ),
            PreorderPage(
              customer: customer,
            ),
            Search(
              customer: customer,
            ),
            Events(
              customer: customer,
            )
          ];

          return Scaffold(
            extendBodyBehindAppBar: false,
            body: _selectedIndex == 0
                ? pages.elementAt(_selectedIndex)
                : Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: pages.elementAt(_selectedIndex)),
            bottomNavigationBar: BottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.home),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.favorite_border_rounded),
                  ),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.checklist_rounded),
                  ),
                  label: 'Preorders',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.search),
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 7),
                    child: Icon(EventTicket.vector),
                  ),
                  label: 'Events',
                ),
              ],
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
