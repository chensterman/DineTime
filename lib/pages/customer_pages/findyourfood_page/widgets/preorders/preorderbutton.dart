import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import '../../blocs/preorderbag/preorderbag_bloc.dart';
import 'preordermenu.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PreorderButton extends StatelessWidget {
  final AuthService clientAuth;
  final String restaurantName;
  final List<MenuItem> menu;
  final PopUpLocation? nextLocation;
  final bool preordersEnabled;
  final bool isVisible;
  const PreorderButton({
    Key? key,
    required this.clientAuth,
    required this.restaurantName,
    required this.menu,
    required this.nextLocation,
    required this.preordersEnabled,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    PreorderBagBloc preorderBagBloc = BlocProvider.of<PreorderBagBloc>(context);
    return Visibility(
      visible: isVisible,
      child: Positioned(
        bottom: 20.0,
        child: SizedBox(
          width: 150.0,
          child: ButtonFilled(
            isDisabled: !preordersEnabled || nextLocation == null,
            text: "Pre-Order",
            onPressed: () {
              services.clientAnalytics.trackEvent('start_preorder');

              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                context: context,
                builder: (context) => PreorderMenu(
                  clientAuth: clientAuth,
                  restaurantName: restaurantName,
                  menu: menu,
                  // replace with nextLocation!
                  nextLocation: PopUpLocation(
                      locationId: "wef",
                      locationAddress: "",
                      locationDateStart: Timestamp(1, 2),
                      locationDateEnd: Timestamp(1, 2),
                      timestamp: Timestamp(1, 2),
                      geolocation: GeoPoint(1, 1),
                      locationName: ""),
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
