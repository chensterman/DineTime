import 'package:dinetime_mobile_mvp/services/auth.dart';
import 'package:dinetime_mobile_mvp/services/location.dart';
import 'package:dinetime_mobile_mvp/ui/root/routing_page/routing_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Routing extends StatelessWidget {
  const Routing({super.key});

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            value: AuthService().streamUserState(), initialData: null),
        StreamProvider<PermissionStatus>.value(
            value: LocationService().getLocationPermissionStatus(),
            initialData: PermissionStatus.granted),
      ],
      child: const RoutingLayout(),
    );
  }
}
