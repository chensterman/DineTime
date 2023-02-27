import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class Dietary extends StatelessWidget {
  final List<r.MenuItem> menu;
  const Dietary({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set dietSet = {};
    for (r.MenuItem menuItem in menu) {
      dietSet.addAll(menuItem.dietaryTags);
    }

    List<Widget> wrapChildren = [];
    for (String diet in dietSet) {
      wrapChildren.add(dietCard(context, r.dietToImagePath[diet]!, diet));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary Options',
          style: dineTimeTypography.headlineMedium,
        ),
        const SizedBox(height: 10),
        wrapChildren.isEmpty
            ? Text(
                'No dietary information.',
                style: dineTimeTypography.bodyMedium?.copyWith(
                  color: dineTimeColorScheme.onSurface,
                ),
              )
            : Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: wrapChildren,
              ),
      ],
    );
  }

  Widget dietCard(BuildContext context, String imagePath, String diet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 30,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: const Color.fromARGB(95, 158, 158, 158), width: 2),
          borderRadius: BorderRadius.circular(7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Text(
            diet,
            style: dineTimeTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
