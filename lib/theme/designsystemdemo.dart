import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';

// Design System demo
class DesignSystem extends StatefulWidget {
  const DesignSystem({super.key});

  @override
  State<DesignSystem> createState() => _DesignSystemState();
}

class _DesignSystemState extends State<DesignSystem> {
  // Form validation
  final _formKey = GlobalKey<FormState>();

  // Slider values
  RangeValues _sliderValues = const RangeValues(0.0, 100.0);

  // Price selector values
  static const List<Widget> _dollarSigns = <Widget>[
    Text('\$'),
    Text('\$\$'),
    Text('\$\$\$'),
    Text('\$\$\$\$'),
  ];
  final List<bool> _selectedPrice = <bool>[false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DineTime Design System"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 42.0,
                    height: 42.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 42.0,
                    height: 42.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 42.0,
                    height: 42.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 42.0,
                    height: 42.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text('Header', style: Theme.of(context).textTheme.headline1),
                  Text('Sub Heading',
                      style: Theme.of(context).textTheme.subtitle1),
                  Text('Body', style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Image(
                          image: AssetImage('lib/assets/dinetime-orange.png'))),
                  const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child:
                          Image(image: AssetImage('lib/assets/location.png'))),
                  const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Image(image: AssetImage('lib/assets/inbox.png'))),
                  const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Image(image: AssetImage('lib/assets/person.png'))),
                  const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Image(image: AssetImage('lib/assets/google.png'))),
                  const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Image(image: AssetImage('lib/assets/apple.png'))),
                  const SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child:
                          Image(image: AssetImage('lib/assets/instagram.png'))),
                  const SizedBox(height: 10),
                  ButtonFilled(
                    text: "Button Filled",
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  ButtonOutlined(
                    text: "Button Outlined",
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  InputText(
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter an something' : null,
                    onChanged: (val) {
                      _formKey.currentState!.validate();
                    },
                    hintText: 'Text Input',
                  ),
                  const SizedBox(height: 10),
                  InputPassword(
                    validator: (val) => val!.length < 8
                        ? 'Password must be at least 8 characters'
                        : null,
                    onChanged: (val) {
                      _formKey.currentState!.validate();
                    },
                    hintText: 'Password Input',
                  ),
                  const SizedBox(height: 10),
                  SliderModule(
                    values: _sliderValues,
                    min: 0.0,
                    max: 100.0,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _sliderValues = values;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  PriceSelector(
                    isSelected: _selectedPrice,
                    children: _dollarSigns,
                    onPressed: (int index) {
                      setState(() {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _selectedPrice.length; i++) {
                          _selectedPrice[i] = i == index;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
