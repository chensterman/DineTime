import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NextTime extends StatelessWidget {
  final Timestamp locationDateStart;
  final Timestamp? locationDateEnd;
  final String imagePath;
  final Color color;
  const NextTime({
    Key? key,
    required this.locationDateStart,
    required this.locationDateEnd,
    required this.imagePath,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String periodStart = locationDateStart.toDate().hour > 12 ? "PM" : "AM";
    num hourStart = locationDateStart.toDate().hour % 12;
    num minuteStart = locationDateStart.toDate().minute;
    String? periodEnd;
    num? hourEnd;
    num? minuteEnd;
    if (locationDateEnd != null) {
      String periodEnd = locationDateEnd!.toDate().hour > 12 ? "PM" : "AM";
      num hourEnd = locationDateEnd!.toDate().hour % 12;
      num minuteEnd = locationDateEnd!.toDate().minute;
    }
    String timeZoneName = locationDateStart.toDate().timeZoneName;

    String timeDisplay = "";
    if (locationDateEnd != null) {
      timeDisplay = "$hourStart:$minuteStart $periodStart $timeZoneName";
    } else {
      "$hourStart:$minuteStart $periodStart - $hourEnd:$minuteEnd $periodEnd $timeZoneName";
    }
    return Row(
      children: [
        const SizedBox(width: 1.0),
        Image.asset(
          imagePath,
          width: 13,
          height: 13,
        ),
        const SizedBox(width: 10.5),
        Text(
          timeDisplay,
          style: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 12.0,
              color: color,
              fontFamily: 'Lato',
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
