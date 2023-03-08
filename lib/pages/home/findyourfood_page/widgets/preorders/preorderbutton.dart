import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/content/menuoption.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/preorders/preordermenu.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/preorders/preorderoption.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class PreorderButton extends StatelessWidget {
  final List<MenuItem> menu;
  const PreorderButton({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0,
      child: SizedBox(
        width: 150.0,
        child: ButtonFilled(
          isDisabled: false,
          text: "Pre-Order",
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              context: context,
              builder: (context) => PreorderMenu(menu: menu),
            );
          },
        ),
      ),
    );
  }
}
