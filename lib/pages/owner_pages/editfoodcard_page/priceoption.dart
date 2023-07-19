import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class PriceOption extends StatefulWidget {
  final int selected;
  final Function(int) onSelect;

  PriceOption({
    required this.selected,
    required this.onSelect,
  });

  @override
  _PriceOptionState createState() => _PriceOptionState();
}

class _PriceOptionState extends State<PriceOption> {
  final List<int> _options = const [1, 2, 3, 4];
  int? _selected;

  @override
  void initState() {
    super.initState();
    // This allows us to intilize states of fields with constructor argument
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selected = widget.selected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var option in _options)
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = option;
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
                color: _selected == option
                    ? dineTimeColorScheme.primary
                    : Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Center(
                child: Text(
                  "\$" * option,
                  style: TextStyle(
                    color: _selected == option
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
