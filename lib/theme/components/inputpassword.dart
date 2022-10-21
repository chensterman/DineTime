import 'package:flutter/material.dart';

// Input password text for form fields
class InputPassword extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  const InputPassword({
    super.key,
    this.validator,
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
  Icon passObscureIcon = const Icon(Icons.visibility);

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
        validator: widget.validator,
        onChanged: widget.onChanged,
        // Additional styling added to the input form field
        decoration: InputDecoration(
          // Centers the hinttext better
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyText1,
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
                setState(
                    () => passObscureIcon = const Icon(Icons.visibility_off));
              } else {
                setState(() => passObscureIcon = const Icon(Icons.visibility));
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
