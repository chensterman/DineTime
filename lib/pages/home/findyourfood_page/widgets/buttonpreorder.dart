import 'package:flutter/material.dart';

// Outlined button used across multiple forms
class ButtonPreOrder extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const ButtonPreOrder({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: InkWell(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 135,
            height: 25,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        image: AssetImage('lib/assets/view_menu.png'),
                        height: 10,
                        width: 10),
                    const SizedBox(width: 5),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 10.0,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'Lato'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
