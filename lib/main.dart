import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:dinetime_mobile_mvp/theme/designsystemdemo.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/getrestaurants.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DineTime Demo',
      theme: ThemeData(
        colorScheme: dineTimeColorScheme,
        textTheme: dineTimeTypography,
      ),
      home: const DesignSystem(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Form validation
  final _formKey = GlobalKey<FormState>();

  // Price selector values
  static const List<Widget> _dollarSigns = <Widget>[
    Text('\$'),
    Text('\$\$'),
    Text('\$\$\$'),
    Text('\$\$\$\$'),
  ];
  final List<bool> _selectedPrice = <bool>[false, false, false, false];

  // Slider values
  RangeValues _sliderValues = const RangeValues(0.0, 100.0);

  // Text input values
  String textInput = "";

  // Restaurant data
  List<Restaurant>? _restaurantList;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image(
                        image: AssetImage('lib/assets/dinetime-orange.png'))),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 50),
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
                const SizedBox(height: 20),
                SliderModule(
                  values: _sliderValues,
                  min: 0.0,
                  max: 100.0,
                  units: 'mi',
                  onChanged: (RangeValues values) {
                    setState(() {
                      _sliderValues = values;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300.0),
                  child: InputText(
                    hintText: 'I\'m hungry for...',
                    onChanged: (val) {
                      setState(() => textInput = val);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300.0),
                  child: ButtonFilled(
                    text: 'Find Your Food!',
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      Location location = Location();
                      bool serviceEnabled = await location.serviceEnabled();
                      if (!serviceEnabled) {
                        serviceEnabled = await location.requestService();
                      }
                      PermissionStatus permissionGranted =
                          await location.hasPermission();
                      if (permissionGranted == PermissionStatus.denied) {
                        permissionGranted = await location.requestPermission();
                      }
                      LocationData locationData = await location.getLocation();
                      dynamic restaurantData = await GetRestaurants().getPlaces(
                          locationData.latitude!,
                          locationData.longitude!,
                          1500,
                          textInput,
                          4);
                      setState(() {
                        if (restaurantData['status'] == 200) {
                          _restaurantList = restaurantData['restaurants'];
                        }
                        _isLoading = false;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading) const CircularProgressIndicator(),
                if (_restaurantList != null)
                  for (Restaurant restaurant in _restaurantList!)
                    Container(
                      constraints: const BoxConstraints(maxWidth: 450.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: restaurant.image,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        restaurant.name != null
                                            ? restaurant.name!
                                            : "N/A",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            )),
                                    Row(children: [
                                      Text("Price Level: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      Text(
                                          restaurant.priceLevel != null
                                              ? "\$" * restaurant.priceLevel!
                                              : "N/A",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1),
                                    ]),
                                    Row(children: [
                                      Text("Rating: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      Text(
                                          restaurant.rating != null
                                              ? restaurant.rating!.toString()
                                              : "N/A",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
