import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/blocs/preorderbag/preorderbag_bloc.dart';
import 'package:dinetime_mobile_mvp/pages/home/findyourfood_page/widgets/preorders/preordermenu.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreorderButton extends StatelessWidget {
  final String restaurantName;
  final List<MenuItem> menu;
  final PopUpLocation? nextLocation;
  final bool isVisible;
  const PreorderButton({
    Key? key,
    required this.restaurantName,
    required this.menu,
    required this.nextLocation,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreorderBagBloc preorderBagBloc = BlocProvider.of<PreorderBagBloc>(context);
    return Visibility(
      visible: isVisible,
      child: Positioned(
        bottom: 20.0,
        child: SizedBox(
          width: 150.0,
          child: ButtonFilled(
            isDisabled: nextLocation == null ? true : false,
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
                builder: (context) => PreorderMenu(
                  restaurantName: restaurantName,
                  menu: menu,
                  nextLocation: nextLocation!,
                  preorderBagBloc: preorderBagBloc,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
