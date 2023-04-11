import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';
import 'cuisineselection.dart';

class CuisineType extends StatefulWidget {
  CuisineType({
    Key? key,
  });

  @override
  _CuisineTypeState createState() => _CuisineTypeState();
}

List<String> imageAssets = [
  "lib/assets/vegan.png",
  "lib/assets/vegetarian.png",
  "lib/assets/pescatarian.png",
  "lib/assets/paleo.png",
  "lib/assets/keto.png",
  "lib/assets/nut_free.png",
];
List<String> cuisineTypes = [
  "Indian",
  "Vietnamese",
  "Greek",
  "American",
  "Mexican",
  "Chinese",
];

class _CuisineTypeState extends State<CuisineType> {
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 0,
              top: 25.0,
              bottom: 0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        size: 30,
                      ),
                      color: dineTimeColorScheme.primary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Cuisine Type",
                                  style: dineTimeTypography.headlineLarge,
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Select the most relevant",
                                  style: dineTimeTypography.bodyLarge?.copyWith(
                                    color: dineTimeColorScheme.primary,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.0),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cuisineTypes.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                    height:
                                        20.0); // Add a SizedBox with a height of 10
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return CuisineSelection(
                                  cuisineName: cuisineTypes[index],
                                  imageAsset: imageAssets[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: dineTimeColorScheme.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(double.infinity, 45),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Done',
                                    style: dineTimeTypography.headlineSmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBottomSheet,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cuisine Type",
                style: dineTimeTypography.bodySmall,
              ),
              const SizedBox(height: 2.0),
              Text(
                "Indian",
                style: dineTimeTypography.bodySmall
                    ?.copyWith(color: dineTimeColorScheme.onSurface),
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: dineTimeColorScheme.primary,
          ),
        ],
      ),
    );
  }
}
