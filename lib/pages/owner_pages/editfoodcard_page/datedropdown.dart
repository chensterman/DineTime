import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String selectedMonth = 'Month';
  String selectedDay = 'Day';
  String selectedYear = 'Year';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 48,
          width: 110,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedMonth,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedMonth = newValue;
                      });
                    }
                  },
                  underline: SizedBox(),
                  icon: null,
                  iconSize: 0.0,
                  items: <String>[
                    'Month',
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
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: dineTimeTypography.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.grey,
              ),
              SizedBox(width: 5.0)
            ],
          ),
        ),
        Container(
          height: 48,
          width: 90,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedDay,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedDay = newValue;
                      });
                    }
                  },
                  underline: SizedBox(),
                  icon: null,
                  iconSize: 0.0,
                  items: <String>[
                    'Day',
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12',
                    '13',
                    '14',
                    '15',
                    '16',
                    '17',
                    '18',
                    '19',
                    '20',
                    '21',
                    '22',
                    '23',
                    '24',
                    '25',
                    '26',
                    '27',
                    '28',
                    '29',
                    '30',
                    '31'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: dineTimeTypography.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.grey,
              ),
              SizedBox(width: 5.0)
            ],
          ),
        ),
        Container(
          height: 48,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedYear,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                    }
                  },
                  underline: SizedBox(),
                  icon: null,
                  iconSize: 0.0,
                  items: <String>[
                    'Year',
                    '2023',
                    '2024',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: dineTimeTypography.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.grey,
              ),
              SizedBox(width: 5.0)
            ],
          ),
        ),
      ],
    );
  }
}
