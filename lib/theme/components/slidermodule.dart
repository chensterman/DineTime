import 'package:flutter/material.dart';

// Slider module for range selection
class SliderModule extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final String? description;
  final String? units;
  final ValueChanged<RangeValues>? onChanged;
  const SliderModule({
    super.key,
    required this.values,
    required this.min,
    required this.max,
    this.description,
    this.units,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    String unitsActual = units != null ? units! : "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${values.start.round()} $unitsActual",
                style: Theme.of(context).textTheme.subtitle1),
            SliderTheme(
              data: SliderThemeData(
                thumbColor: Theme.of(context).colorScheme.onPrimary,
                activeTrackColor: Theme.of(context).colorScheme.primary,
              ),
              child: RangeSlider(
                values: values,
                min: min,
                max: max,
                divisions: (max - min).toInt(),
                onChanged: onChanged,
              ),
            ),
            Text("${values.end.round()} $unitsActual",
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
        description != null
            ? Text(
                description!,
                style: Theme.of(context).textTheme.subtitle1,
              )
            : Container(),
      ],
    );
  }
}
