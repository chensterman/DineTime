import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/theme/colorscheme.dart';
import 'package:dinetime_mobile_mvp/theme/typography.dart';
import 'package:flutter/material.dart';

class NextDate extends StatelessWidget {
  final Timestamp locationDateStart;
  final String imagePath;
  final Color color;
  NextDate({
    Key? key,
    required this.locationDateStart,
    required this.imagePath,
    required this.color,
  }) : super(key: key);

  final List<String> _months = [
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

  @override
  Widget build(BuildContext context) {
    String nextDate =
        '${_months[locationDateStart.toDate().month - 1]} ${locationDateStart.toDate().day}, ${locationDateStart.toDate().year}';
    String daysAway =
        '${locationDateStart.toDate().difference(DateTime.now()).inDays} days away';
    return Row(
      children: [
        const SizedBox(width: 0.5),
        Image.asset(
          imagePath,
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 10.5),
        Text(
          nextDate,
          style: dineTimeTypography.bodyMedium?.copyWith(
            color: color,
          ),
        ),
        const SizedBox(width: 13),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 60,
            height: 25,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              shape: BoxShape.rectangle,
            ),
            child: Text(
              daysAway,
              style: dineTimeTypography.bodyMedium?.copyWith(
                color: dineTimeColorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
