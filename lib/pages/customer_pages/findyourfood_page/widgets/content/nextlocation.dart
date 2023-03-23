import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class NextLocation extends StatelessWidget {
  final List<PopUpLocation> upcomingLocations;
  final bool onMainDetails;
  const NextLocation({
    Key? key,
    required this.upcomingLocations,
    required this.onMainDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PopUpLocation? nextLocation =
        upcomingLocations.isEmpty ? null : upcomingLocations[0];
    String? name = nextLocation?.locationName;
    Timestamp? dateStart = nextLocation?.locationDateStart;
    Timestamp? dateEnd = nextLocation?.locationDateEnd;
    return Column(
      children: [
        locationName(name),
        const SizedBox(height: 7),
        locationDateStart(dateStart),
        const SizedBox(height: 7),
        locationTime(dateStart, dateEnd),
      ],
    );
  }

  Widget locationName(String? name) {
    return Row(
      children: [
        Image.asset(
          onMainDetails
              ? 'lib/assets/location_white.png'
              : 'lib/assets/location_arrow_orange.png',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 10.5),
        Text(
          name ?? "TBD",
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: onMainDetails
                ? dineTimeColorScheme.background
                : dineTimeColorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget locationDateStart(Timestamp? date) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    String nextDate = date == null
        ? 'TBD'
        : '${months[date.toDate().month - 1]} ${date.toDate().day}, ${date.toDate().year}';

    int daysAwayInt =
        date == null ? 0 : date.toDate().difference(DateTime.now()).inDays;
    String daysAway = daysAwayInt == 0 ? 'Today' : '$daysAwayInt Days Away';

    return Row(
      children: [
        const SizedBox(width: 0.5),
        Image.asset(
          onMainDetails
              ? 'lib/assets/calendar.png'
              : 'lib/assets/calendar_orange.png',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 10.5),
        Text(
          nextDate,
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: onMainDetails
                ? dineTimeColorScheme.background
                : dineTimeColorScheme.onBackground,
          ),
        ),
        const SizedBox(width: 13),
        date != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 120,
                  height: 25,
                  decoration: BoxDecoration(
                    color: dineTimeColorScheme.primary.withOpacity(0.7),
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child: Text(
                      daysAway,
                      style: dineTimeTypography.bodyMedium?.copyWith(
                        color: dineTimeColorScheme.onPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget locationTime(Timestamp? dateStart, Timestamp? dateEnd) {
    String timeDisplay = "TBD";
    if (dateStart != null) {
      String periodStart = dateStart.toDate().hour > 12 ? "PM" : "AM";
      String timeZoneName = dateStart.toDate().timeZoneName;
      num hourStart = dateStart.toDate().hour % 12;
      String hourStartString =
          (hourStart / 10).floor() == 0 ? "0$hourStart" : "$hourStart";
      num minuteStart = dateStart.toDate().minute;
      String minuteStartString =
          (minuteStart / 10).floor() == 0 ? "0$minuteStart" : "$minuteStart";

      String? periodEnd;
      num? hourEnd;
      String? hourEndString;
      num? minuteEnd;
      String? minuteEndString;
      if (dateEnd != null) {
        periodEnd = dateEnd.toDate().hour > 12 ? "PM" : "AM";
        hourEnd = dateEnd.toDate().hour % 12;
        hourEndString = (hourEnd / 10).floor() == 0 ? "0$hourEnd" : "$hourEnd";
        minuteEnd = dateEnd.toDate().minute;
        minuteEndString =
            (minuteEnd / 10).floor() == 0 ? "0$minuteEnd" : "$minuteEnd";
        timeDisplay =
            "$hourStartString:$minuteStartString $periodStart - $hourEndString:$minuteEndString $periodEnd $timeZoneName";
      } else {
        timeDisplay =
            "$hourStartString:$minuteStartString $periodStart $timeZoneName - Until Sold Out";
      }
    }

    return Row(
      children: [
        const SizedBox(width: 1.0),
        Image.asset(
          onMainDetails
              ? 'lib/assets/clock_white.png'
              : 'lib/assets/clock_orange.png',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 10.5),
        Text(
          timeDisplay,
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: onMainDetails
                ? dineTimeColorScheme.background
                : dineTimeColorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
