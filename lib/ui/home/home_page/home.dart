import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/ui/home/findyourfood_page/findyourfood.dart';
import 'package:dinetime_mobile_mvp/ui/home/favorites_page/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  User user = AuthService().getCurrentUser()!;

  // User's address displayed at top of the application
  String displayAddress = "";

  // Update selected index for BottomNavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get user location, update the user data, and create address
  Future<String> _updateUserLocation() async {
    GeoPoint? userLocation = await LocationService().getLocationData();
    await DatabaseService().updateCustomer(user.uid, {
      'geolocation': userLocation,
    });
    String? address = "";
    if (userLocation != null) {
      address = await LocationService().geopointToAddress(userLocation);
    }
    if (address != null) {
      displayAddress = address;
    }
    return displayAddress;
  }

  @override
  void initState() {
    _updateUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Widget list for bottom nav bar
    final List<Widget> pages = <Widget>[
      FindYourFood(customerId: user.uid),
      Favorites(customerId: user.uid),
    ];
    // Main page widget (contains nav bar pages as well)
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
