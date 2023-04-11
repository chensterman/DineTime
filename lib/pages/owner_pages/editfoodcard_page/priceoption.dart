import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class PriceOption extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelect;

  PriceOption({required this.options, required this.onSelect});

  @override
  _PriceOptionState createState() => _PriceOptionState();
}

class _PriceOptionState extends State<PriceOption> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var option in widget.options)
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedOption = option;
              });
              widget.onSelect(option);
            },
            child: Container(
              width: 75,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: dineTimeColorScheme.primary,
                  width: 1.0,
                ),
                color: _selectedOption == option
                    ? dineTimeColorScheme.primary
                    : Colors.white,
              ),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: _selectedOption == option
                        ? Colors.white
                        : dineTimeColorScheme.primary,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
