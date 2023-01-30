import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/material.dart';

// Input password text for form fields
class InputPassword extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? hintText;
  const InputPassword({
    super.key,
    this.onChanged,
    this.hintText,
  });

  @override
  // ignore: library_private_types_in_public_api
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  // State of password obscurer
  bool passObscure = true;
  Icon passObscureIcon =
      Icon(Icons.visibility, color: dineTimeColorScheme.onSurface);

  @override
  Widget build(BuildContext context) {
    BorderRadius componentShape = BorderRadius.circular(10);
    // Container to style the form field (white background color and sizing)
    return Stack(children: [
      Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: componentShape,
        ),
      ),
      TextFormField(
        obscureText: passObscure,
        cursorColor: Theme.of(context).colorScheme.onBackground,
        onChanged: widget.onChanged,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
        // Additional styling added to the input form field
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: componentShape,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1.0,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: componentShape,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1.0,
              )),
          // Centers the hinttext better
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyText2,
          // Border colors when normal and on error
          border: OutlineInputBorder(
              borderRadius: componentShape,
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface, width: 1.0)),
          errorBorder: OutlineInputBorder(
              borderRadius: componentShape,
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onError, width: 1.0)),
          suffixIcon: IconButton(
            onPressed: () {
              // Logic to reveal typed password
              if (passObscure) {
                setState(() => passObscureIcon = Icon(Icons.visibility_off,
                    color: dineTimeColorScheme.onSurface));
              } else {
                setState(() => passObscureIcon = Icon(Icons.visibility,
                    color: dineTimeColorScheme.onSurface));
              }
              setState(() => passObscure = !passObscure);
            },
            icon: passObscureIcon,
          ),
        ),
      ),
    ]);
  }
}
