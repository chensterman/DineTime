import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingLocations extends StatelessWidget {
  final List<PopUpLocation> popUpLocations;
  final GeoPoint customerLocation;
  const UpcomingLocations({
    Key? key,
    required this.popUpLocations,
    required this.customerLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [
      Text(
        'Upcoming Locations',
        style: dineTimeTypography.headlineMedium,
      ),
      const SizedBox(height: 10),
      popUpLocations.isEmpty
          ? Text(
              'No upcoming locations.',
              style: dineTimeTypography.bodyMedium?.copyWith(
                color: dineTimeColorScheme.onSurface,
              ),
            )
          : Container(),
    ];
    // num count = 0;
    for (PopUpLocation popUpLocation in popUpLocations) {
      columnChildren.add(const SizedBox(
        height: 10.0,
      ));
      columnChildren.add(upcomingLocationCard(
        context,
        popUpLocation.geolocation,
        popUpLocation.locationDateStart,
        popUpLocation.locationDateEnd,
        popUpLocation.locationName,
        popUpLocation.locationAddress,
      ));
      // count += 1;
      // if (count == 3) {
      //   break;
      // }
    }
    // columnChildren.add(Center(
    //   child: locationsButton(context),
    // ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }

  Widget upcomingLocationCard(
    BuildContext context,
    GeoPoint geocode,
    Timestamp locationDateStart,
    Timestamp? locationDateEnd,
    String name,
    String address,
  ) {
    String periodStart = locationDateStart.toDate().hour > 12 ? "PM" : "AM";
    num hourStart = locationDateStart.toDate().hour % 12;
    num minuteStart = locationDateStart.toDate().minute;
    String? periodEnd;
    num? hourEnd;
    num? minuteEnd;
    if (locationDateEnd != null) {
      String periodEnd = locationDateEnd.toDate().hour > 12 ? "PM" : "AM";
      num hourEnd = locationDateEnd.toDate().hour % 12;
      num minuteEnd = locationDateEnd.toDate().minute;
    }
    String timeZoneName = locationDateStart.toDate().timeZoneName;

    String timeDisplay = "";
    if (locationDateEnd != null) {
      timeDisplay = "$hourStart:$minuteStart $periodStart $timeZoneName";
    } else {
      "$hourStart:$minuteStart $periodStart - $hourEnd:$minuteEnd $periodEnd $timeZoneName";
    }

    Services services = Provider.of<Services>(context);
    double distance = services.clientLocation
        .distanceBetweenTwoPoints(customerLocation, geocode);
    String infoText = "$distance mi - $timeDisplay";
    return ListCard(
      height: 60.0,
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '${locationDateStart.toDate().month}/${locationDateStart.toDate().day}',
              style: dineTimeTypography.headlineSmall?.copyWith(
                color: dineTimeColorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text overflow works by wrapping text under Flexible widget
                    Flexible(
                      child: Text(
                        name,
                        style: dineTimeTypography.headlineSmall?.copyWith(
                          color: dineTimeColorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    Flexible(
                      child: Text(
                        infoText,
                        style: dineTimeTypography.bodySmall?.copyWith(
                          color: dineTimeColorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: () => launchUrl(Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=${address}')),
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    // Display image based on availability of user uploaded image
                    fit: BoxFit.fill,
                    image: AssetImage('lib/assets/location_arrow_grey.png'),
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          )
        ],
      ),
    );
  }

  // Widget locationsButton(BuildContext context) {
  //   List<Widget> columnChildren = [];
  //   for (PopUpLocation popUpLocation in popUpLocations) {
  //     columnChildren.add(const SizedBox(
  //       height: 10.0,
  //     ));
  //     columnChildren.add(upcomingLocationCard(
  //         context,
  //         popUpLocation.geolocation,
  //         popUpLocation.locationDateStart,
  //         popUpLocation.locationDateEnd,
  //         popUpLocation.locationName,
  //         popUpLocation.locationAddress));
  //   }
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
  //     child: InkWell(
  //         onTap: () {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return upcomingLocationsDialog(context, columnChildren);
  //             },
  //           );
  //         },
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(10),
  //           child: Container(
  //             width: 250,
  //             height: 26,
  //             decoration: BoxDecoration(
  //               color: dineTimeColorScheme.primary.withOpacity(0.2),
  //               shape: BoxShape.rectangle,
  //             ),
  //             child: Center(
  //                 child: Center(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Image(
  //                       image:
  //                           AssetImage('lib/assets/location_arrow_orange.png'),
  //                       height: 15,
  //                       width: 15),
  //                   const SizedBox(width: 7),
  //                   Text(
  //                     "View all upcoming locations",
  //                     style: dineTimeTypography.bodySmall?.copyWith(
  //                       color: dineTimeColorScheme.primary,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )),
  //           ),
  //         )),
  //   );
  // }

  // Widget upcomingLocationsDialog(
  //     BuildContext context, List<Widget> columnChildren) {
  //   return Dialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20.0),
  //     ),
  //     child: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(25.0),
  //         child: Column(
  //           children: [
  //             Align(
  //               alignment: Alignment.topLeft,
  //               child: InkWell(
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Row(
  //                   children: [
  //                     const Image(
  //                         image: AssetImage('lib/assets/back_arrow.png'),
  //                         height: 12,
  //                         width: 12),
  //                     const SizedBox(width: 10),
  //                     Text(
  //                       "Go Back",
  //                       style: dineTimeTypography.bodySmall?.copyWith(
  //                         color: dineTimeColorScheme.primary,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Align(
  //               alignment: Alignment.center,
  //               child: Row(
  //                 children: [
  //                   Text(
  //                     'Upcoming Locations',
  //                     style: dineTimeTypography.headlineMedium,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Scrollbar(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: columnChildren,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
