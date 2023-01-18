import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:dinetime_mobile_mvp/provider/card_provider.dart';

class MenuButton extends StatelessWidget {
  final String price;
  final String image;
  final String itemName;
  final String itemDesc;

  const MenuButton({
    super.key,
    required this.price,
    required this.image,
    required this.itemName,
    required this.itemDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.68,
                    width: MediaQuery.of(context).size.width * 0.9,
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
                                    image:
                                        AssetImage('lib/assets/back_arrow.png'),
                                    height: 15,
                                    width: 15),
                                const SizedBox(width: 10),
                                Text(
                                  "Go Back",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          fontSize: 15.0,
                                          fontFamily: 'Lato',
                                          color: dineTimeColorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Text(
                                "Menu",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 25.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.57,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  MenuOptions(
                                      price: widget.user.menuprice1,
                                      image: widget.user.menuph1,
                                      itemName: widget.user.menu1,
                                      itemDesc: widget.user.menudesc1),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice2,
                                      image: widget.user.menuph2,
                                      itemName: widget.user.menu2,
                                      itemDesc: widget.user.menudesc2),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice3,
                                      image: widget.user.menuph3,
                                      itemName: widget.user.menu3,
                                      itemDesc: widget.user.menudesc3),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice1,
                                      image: widget.user.menuph1,
                                      itemName: widget.user.menu1,
                                      itemDesc: widget.user.menudesc1),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice2,
                                      image: widget.user.menuph2,
                                      itemName: widget.user.menu2,
                                      itemDesc: widget.user.menudesc2),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice3,
                                      image: widget.user.menuph3,
                                      itemName: widget.user.menu3,
                                      itemDesc: widget.user.menudesc3),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice2,
                                      image: widget.user.menuph2,
                                      itemName: widget.user.menu2,
                                      itemDesc: widget.user.menudesc2),
                                  Divider(
                                      color: Color.fromARGB(95, 158, 158, 158),
                                      height: 1),
                                  MenuOptions(
                                      price: widget.user.menuprice3,
                                      image: widget.user.menuph3,
                                      itemName: widget.user.menu3,
                                      itemDesc: widget.user.menudesc3),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 250,
            height: 22,
            decoration: BoxDecoration(
              color: dineTimeColorScheme.primary.withOpacity(0.2),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "View full menu",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 10.0,
                          color: dineTimeColorScheme.primary,
                          fontFamily: 'Lato'),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward,
                      color: dineTimeColorScheme.primary,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
