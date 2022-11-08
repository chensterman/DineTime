import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/views/locationpreferences.dart';
import 'package:flutter/material.dart';

class DiningPreferences extends StatefulWidget {
  final Map<String, dynamic> userData;
  const DiningPreferences({Key? key, required this.userData}) : super(key: key);

  @override
  State<DiningPreferences> createState() => _DiningPreferencesState();
}

class _DiningPreferencesState extends State<DiningPreferences> {
  // Form state values
  String cuisine = "";
  String zipcode = "";
  RangeValues _sliderValues = const RangeValues(0.0, 50.0);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const ProgressBar(percentCompletion: 0.6),
                const SizedBox(height: 60.0),
                Text(
                  "Set your dining preferences",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 50.0),
                Text(
                  "Cuisine",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: 20.0),
                InputText(
                  hintText: "What are you hungry for?",
                  onChanged: (value) {
                    setState(() {
                      cuisine = value;
                    });
                  },
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Zipcode",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: 20.0),
                InputText(
                  hintText: "Zipcode",
                  onChanged: ((value) {
                    setState(() {
                      zipcode = value;
                    });
                  }),
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Distance",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SliderModule(
                        values: _sliderValues,
                        min: 0.0,
                        max: 50.0,
                        units: 'mi',
                        onChanged: (RangeValues values) {
                          setState(() {
                            _sliderValues = values;
                          });
                        },
                      ),
                    ]),
                const SizedBox(height: 30.0),
                Text(
                  "Price Range",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 50.0),
                ButtonFilled(
                  text: "Apply",
                  onPressed: () {
                    Map priceData = {};
                    for (int i = 0; i < _dollarSigns.length; i++) {
                      priceData[_dollarSigns[i]] = _selectedPrice[i];
                    }
                    widget.userData['price'] = priceData;
                    widget.userData['cuisine'] = cuisine;
                    widget.userData['zipcode'] = zipcode;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationPreferences(userData: widget.userData),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Go Back',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          )),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
