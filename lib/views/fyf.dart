import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/material.dart';

class FindYourFood extends StatefulWidget {
  const FindYourFood({Key? key}) : super(key: key);

  @override
  State<FindYourFood> createState() => _FindYourFoodState();
}

class _FindYourFoodState extends State<FindYourFood> {
  // BottomNavBar
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget list for bottom nav bar
    final List<Widget> pages = <Widget>[
      restaurantCards(context),
      savedLists(context),
    ];

    // Main page widget (contains nav bar pages as well)
    return Scaffold(
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
                icon: Icon(Icons.saved_search), label: 'My Lists'),
          ],
        ));
  }

  Widget restaurantCards(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.08,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            InkWell(
              child: Container(
                padding: const EdgeInsets.only(right: 40.0),
                child: Icon(
                  Icons.filter,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 32.0,
                ),
              ),
              onTap: () {},
            )
          ],
        ),
        body: const Center(child: RestaurantCard()));
  }

  Widget savedLists(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My Lists',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 28.0)),
              InkWell(
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32.0,
                ),
                onTap: () {},
              )
            ]),
            const SizedBox(height: 20.0),
            const InputText(
              icon: Icon(Icons.search),
              hintText: 'Search for a restaurant or list',
            ),
          ],
        ),
      ),
    );
  }
}
