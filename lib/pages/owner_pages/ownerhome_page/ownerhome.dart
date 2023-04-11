import 'package:dinetime_mobile_mvp/models/owner.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/pages/owner_pages/commerce_page/commerce.dart';
import 'package:dinetime_mobile_mvp/pages/owner_pages/editfoodcard_page/editfoodcard.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/pages/root/routing_page/routing.dart';

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
            appBar: AppBar(
              title: Text('cool'),
              elevation: 0.0, // Set the elevation to 0 to remove the shadow
              backgroundColor:
                  Colors.white, // Set the background color to white
              iconTheme: IconThemeData(color: dineTimeColorScheme.primary),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return settingsDialog(context);
                      },
                    );
                  },
                ),
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                EditFoodCard(restaurant: owner.restaurants[0]), // commerce page
                Commerce(restaurant: owner.restaurants[0]), // commerce page
              ],
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_note),
                  label: 'My Card',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_checkout_rounded),
                  label: 'Orders',
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

  Widget settingsDialog(BuildContext context) {
    Services services = Provider.of<Services>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      const Image(
                          image: AssetImage('lib/assets/back_arrow.png'),
                          height: 12,
                          width: 12),
                      const SizedBox(width: 10),
                      Text(
                        "Go Back",
                        style: dineTimeTypography.bodySmall
                            ?.copyWith(color: dineTimeColorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ButtonFilled(
                text: "Log Out",
                isDisabled: false,
                onPressed: () {
                  services.clientAuth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const Routing(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ButtonFilled(
                text: "Delete Account",
                isDisabled: false,
                onPressed: () async {
                  Navigator.pop(context);
                  String customerId = services.clientAuth.getCurrentUserUid()!;
                  await services.clientAuth.deleteAccount();
                  await services.clientDB.customerDelete(customerId);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const Routing(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ButtonOutlined(
                text: "Privacy Policy",
                onPressed: () => launchUrl(
                  Uri.parse(
                      "https://app.termly.io/document/privacy-policy/fe314525-5052-4111-b6ab-248cd2aa41c9"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
