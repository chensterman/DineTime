import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CuisineDetails extends StatelessWidget {
  final String cuisine;
  final int pricing;
  final GeoPoint customerLocation;
  final List<PopUpLocation> locations;
  final bool onMainDetails;
  const CuisineDetails({
    Key? key,
    required this.cuisine,
    required this.pricing,
    required this.customerLocation,
    required this.locations,
    required this.onMainDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Services services = Provider.of<Services>(context);
    double? distance;
    if (locations.isNotEmpty) {
      distance = services.clientLocation
          .distanceBetweenTwoPoints(customerLocation, locations[0].geolocation);
    }
    String infoText = distance != null
        ? '$cuisine  ·  ${'\$' * pricing}  ·  $distance mi'
        : '$cuisine  ·  ${'\$' * pricing}';
    return RichText(
      text: TextSpan(
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: onMainDetails
                ? dineTimeColorScheme.background
                : dineTimeColorScheme.onBackground,
          ),
          children: [
            TextSpan(text: infoText),
          ]),
    );
  }
}
