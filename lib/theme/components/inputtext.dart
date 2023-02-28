import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

// Input text for form fields
class InputText extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final Widget? icon;
  const InputText({
    super.key,
    this.onChanged,
    this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius componentShape = BorderRadius.circular(10);
    // Container to style the form field (white background color and sizing)
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: componentShape,
          ),
        ),
        TextFormField(
          cursorColor: dineTimeColorScheme.onBackground,
          onChanged: onChanged,
          style: dineTimeTypography.bodySmall,
          // Additional styling added to the input form field
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide: BorderSide(
                  color: dineTimeColorScheme.onSurface,
                  width: 1.0,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide: BorderSide(
                  color: dineTimeColorScheme.onSurface,
                  width: 1.0,
                )),
            // Centers the hinttext better
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: hintText,
            hintStyle: dineTimeTypography.bodySmall?.copyWith(
              color: dineTimeColorScheme.onSurface,
            ),
            prefixIcon: icon,
            // Border colors when normal and on error
            border: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide: BorderSide(
                  color: dineTimeColorScheme.onSurface,
                  width: 1.0,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide:
                    BorderSide(color: dineTimeColorScheme.onError, width: 1.0)),
          ),
        ),
      ],
    );
  }
}
