import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/graveyard/diningpreferences.dart';
import 'package:flutter/material.dart';

// Page to choose dietary preferences
class DietaryPreferences extends StatefulWidget {
  const DietaryPreferences({Key? key}) : super(key: key);

  @override
  State<DietaryPreferences> createState() => _DietaryPreferencesState();
}

class _DietaryPreferencesState extends State<DietaryPreferences> {
  // List of diets and respective selection
  List<String> listDiets = [
    'Vegan',
    'Vegetarian',
    'Pescatarian',
    'Paleo',
    'Keto',
    'Carnivore',
    'Nut Free',
  ];
  List<bool> selectedDiets = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

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
                const ProgressBar(percentCompletion: 0.4),
                const SizedBox(height: 60.0),
                Text(
                  "Set your dietary preferences",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 30.0),
                Text(
                  "Choose all that apply",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    DietaryButton(
                      text: 'Vegan',
                      onPressed: () {
                        int dietIdx = listDiets.indexOf('Vegan');
                        setState(() {
                          selectedDiets[dietIdx] = !selectedDiets[dietIdx];
                        });
                      },
                    ),
                    const SizedBox(width: 50.0),
                    DietaryButton(
                      text: 'Vegetarian',
                      onPressed: () {
                        int dietIdx = listDiets.indexOf('Vegetarian');
                        setState(() {
                          selectedDiets[dietIdx] = !selectedDiets[dietIdx];
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    DietaryButton(
                      text: 'Pescatarian',
                      onPressed: () {
                        int dietIdx = listDiets.indexOf('Pescatarian');
                        setState(() {
                          selectedDiets[dietIdx] = !selectedDiets[dietIdx];
                        });
                      },
                    ),
                    const SizedBox(width: 50.0),
                    DietaryButton(
                      text: 'Paleo',
                      onPressed: () {
                        int dietIdx = listDiets.indexOf('Paleo');
                        setState(() {
                          selectedDiets[dietIdx] = !selectedDiets[dietIdx];
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    DietaryButton(
                      text: 'Keto',
                      onPressed: () {
                        int dietIdx = listDiets.indexOf('Keto');
                        setState(() {
                          selectedDiets[dietIdx] = !selectedDiets[dietIdx];
                        });
                      },
                    ),
                    const SizedBox(width: 50.0),
                    DietaryButton(
                      text: 'Carnivore',
                      onPressed: () {
                        int dietIdx = listDiets.indexOf('Carnivore');
                        setState(() {
                          selectedDiets[dietIdx] = !selectedDiets[dietIdx];
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    DietaryButton(
                      text: 'Nut Free',
                      onPressed: () {
                        int dietIdx = listDiets.indexOf('Nut Free');
                        setState(() {
                          selectedDiets[dietIdx] = !selectedDiets[dietIdx];
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                ButtonFilled(
                  text: "Apply",
                  onPressed: () {
                    // Put selections into map
                    Map dietaryData = {};
                    for (int i = 0; i < listDiets.length; i++) {
                      dietaryData[listDiets[i]] = selectedDiets[i];
                    }
                    // Add dietary selections to user data map
                    Map<String, dynamic> userData = {'dietary': dietaryData};
                    // Go to next page and pass user data in
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DiningPreferences(userData: userData),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30.0),
                // Widget to navigate to previous page
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
