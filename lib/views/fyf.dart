import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/analytics_service.dart';
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
    AnalyticsService()
        .getInstance()
        .logScreenView(screenClass: 'FYF', screenName: 'FYFPage');
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
                icon: Icon(Icons.favorite_border_rounded), label: 'My Lists'),
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
              onTap: () {
                AuthService().signOut();
              },
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
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My Lists',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 24.0)),

              // InkWell(
              //   child: Icon(
              //     Icons.add_circle_outline_rounded,
              //     color: Theme.of(context).colorScheme.primary,
              //     size: 32.0,
              //   ),
              //   onTap: () {},
              // )
            ]),
            // const SizedBox(height: 20.0),
            // const InputText(
            //   icon: Icon(Icons.search),
            //   hintText: 'Search for a restaurant or list',
            // ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('60 items',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontSize: 14.0)),
            ),
            const SizedBox(height: 20.0),
            const FoodListCard(
                listImage: AssetImage('lib/assets/location.png'),
                listTitle: 'Steph Curry\'s Pop-Up',
                listCuisine: 'Indian',
                listDollars: 2,
                listDistance: 1.6),
            const SizedBox(height: 20.0),
            const FoodListCard(
                listImage: AssetImage('lib/assets/location.png'),
                listTitle: 'Stephen\'s Bakery',
                listCuisine: 'Dessert',
                listDollars: 3,
                listDistance: 3.4),
          ],
        ),
      ),
    );
  }

  Widget foodList(BuildContext context, int listNumItems,
      DateTime? listCreateDate, String listTitle) {
    // Get the time difference from creation date if exists
    int difference = 0;
    if (listCreateDate != null) {
      final now = DateTime.now();
      difference = now.difference(listCreateDate).inDays;
    }
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: height * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  child: Row(children: [
                    Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32.0,
                    ),
                    Text('My Lists',
                        style: Theme.of(context).textTheme.subtitle1),
                  ]),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                InkWell(
                  child: Icon(
                    Icons.ios_share_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32.0,
                  ),
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('lib/assets/dinetime-orange.png'),
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  )),
              const SizedBox(height: 10.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("$listNumItems Items",
                    style: Theme.of(context).textTheme.subtitle1),
                if (listCreateDate != null)
                  Text("  -  ", style: Theme.of(context).textTheme.subtitle1),
                if (listCreateDate != null)
                  Text("Created $difference days ago",
                      style: Theme.of(context).textTheme.subtitle1),
              ]),
              Text(listTitle, style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
