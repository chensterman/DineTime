import 'package:flutter/material.dart';

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
          cursorColor: Theme.of(context).colorScheme.onBackground,
          onChanged: onChanged,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
          // Additional styling added to the input form field
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1.0,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1.0,
                )),
            // Centers the hinttext better
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyText2,
            prefixIcon: icon,
            // Border colors when normal and on error
            border: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1.0,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: componentShape,
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onError, width: 1.0)),
          ),
        ),
      ],
    );
  }
}
