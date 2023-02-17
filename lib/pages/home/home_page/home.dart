import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/findyourfood.dart';
import 'package:dinetime_mobile_mvp/pages/home/favorites_page/favorites.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final DatabaseService clientDB;
  final AuthService clientAuth;
  final LocationService clientLocation;
  final StorageService clientStorage;
  final AnalyticsService clientAnalytics;
  const Home({
    Key? key,
    required this.clientDB,
    required this.clientAuth,
    required this.clientLocation,
    required this.clientStorage,
    required this.clientAnalytics,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // Update selected index for BottomNavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get user location, update the user data, and create address
  Future<void> _updateUserLocation() async {
    String customerId = widget.clientAuth.getCurrentUserUid()!;
    GeoPoint? userLocation = await widget.clientLocation.getLocationData();
    await widget.clientDB.updateCustomer(customerId, {
      'geolocation': userLocation,
    });
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
      FindYourFood(
        clientDB: widget.clientDB,
        clientAuth: widget.clientAuth,
        clientStorage: widget.clientStorage,
        clientAnalytics: widget.clientAnalytics,
      ),
      Favorites(
        clientDB: widget.clientDB,
        clientAuth: widget.clientAuth,
        clientStorage: widget.clientStorage,
      ),
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
