import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/views/home/findyourfood.dart';
import 'package:dinetime_mobile_mvp/views/home/savedfood.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
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
    Analytics()
        .getInstance()
        .logScreenView(screenClass: 'FYF', screenName: 'Home');
    double height = MediaQuery.of(context).size.height;
    // Widget list for bottom nav bar
    final List<Widget> pages = <Widget>[
      const FindYourFood(),
      SavedFood(
        customerId: user.uid,
      ),
    ];
    final List<PreferredSizeWidget> appBar = <PreferredSizeWidget>[
      AppBar(
        shadowColor: dineTimeColorScheme.onPrimary,
        toolbarHeight: height * 0.08,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
                color: dineTimeColorScheme.onPrimary, height: height * .08),
            Container(
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('lib/assets/location.png'),
                ),
                color: dineTimeColorScheme.onPrimary,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            FutureBuilder(
                future: _updateUserLocation(),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      displayAddress,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 18.0),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    ];
    // Main page widget (contains nav bar pages as well)
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: _selectedIndex == 0 ? appBar.elementAt(_selectedIndex) : null,
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
                icon: Icon(Icons.favorite_border_rounded), label: 'My Lists'),
          ],
        ));
  }
}
