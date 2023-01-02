import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/views/home/findyourfood.dart';
import 'package:dinetime_mobile_mvp/views/home/savedfood.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  User user = AuthService().getCurrentUser()!;

  // Update selected index for BottomNavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get user location and update the user data
  Future<void> _updateUserLocation() async {
    GeoPoint? userLocation = await LocationService().getLocationData();
    await DatabaseService().updateCustomer(user.uid, {
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
      const FindYourFood(),
      SavedFood(
        customerId: user.uid,
      ),
    ];

    double height = MediaQuery.of(context).size.height;
    // Main page widget (contains nav bar pages as well)
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.08,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('lib/assets/location.png'),
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                "Bellevue, WA 98004",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 18.0),
              ),
            ],
          ),
          actions: [
            InkWell(
              child: Container(
                padding: const EdgeInsets.only(right: 40.0),
                child: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 32.0,
                ),
              ),
              onTap: () async {
                await AuthService().signOut();
              },
            )
          ],
        ),
        body: pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded), label: 'My Lists'),
          ],
        ));
  }
}
