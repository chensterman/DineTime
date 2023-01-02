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

  String dropdownvalue = '';

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

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
                icon: Icon(Icons.favorite_border_rounded), label: 'My Lists'),
          ],
        ));
  }

  Widget restaurantCards(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          title: Container(
            height: 40.0,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/Group.png',
                  height: 24.0,
                  width: 24.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Bellevue, WA 98004',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 15.0,
                      ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                'lib/assets/notification_bell.png',
                width: 24.0,
                height: 24.0,
              ),
              onPressed: () {},
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
            const SizedBox(height: 20.0),
            ListCard(
              listTitle: 'My Favorites',
              listNumItems: 60,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          foodList(context, 60, null, 'My Favorites')),
                )
              },
            ),
            const SizedBox(height: 20.0),
            ListCard(
              listTitle: 'Vegan Food',
              listNumItems: 22,
              listCreateDate: DateTime(2022, 9, 7),
              onTap: () => {},
            ),
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
