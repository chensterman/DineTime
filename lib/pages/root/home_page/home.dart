import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/findyourfood_page/findyourfood.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/favorites_page/favorites.dart';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/pages/business_pages/completedpreorders_page/preorders.dart';
import 'package:dinetime_mobile_mvp/pages/business_pages/businessorders_page/businessorders.dart';
import 'package:dinetime_mobile_mvp/pages/customer_pages/search_page/search.dart';

class Home extends StatefulWidget {
  final Services services;
  const Home({
    Key? key,
    required this.services,
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
    String customerId = widget.services.clientAuth.getCurrentUserUid()!;
    GeoPoint? userLocation =
        await widget.services.clientLocation.getLocationData();
    await widget.services.clientDB.customerUpdate(customerId, {
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
    // Main page widget (contains nav bar pages as well)
    return FutureBuilder(
      future: widget.services.clientDB
          .customerGet(widget.services.clientAuth.getCurrentUserUid()!),
      builder: ((context, AsyncSnapshot<Customer?> snapshot) {
        if (snapshot.hasError) {
          return Container();
          // On success
        } else if (snapshot.connectionState == ConnectionState.done) {
          Customer? customer = snapshot.data;
          if (customer == null) {
            return Container();
          } else {
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
              // BusinessOrderPage(
              //     // customer: customer,
              //     ),
              Search(
                customer: customer,
              ),
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
                  // BottomNavigationBarItem(
                  //   icon: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //     child: Icon(Icons.shopping_cart_outlined),
                  //   ),
                  //   label: 'Orders',
                  // ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.search),
                    ),
                    label: 'Directory',
                  ),
                ],
              ),
            );
          }
          // On loading
        } else {
          return const LoadingScreen();
        }
      }),
    );
  }
}
