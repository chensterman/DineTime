import 'package:flutter/material.dart';

// Cards that display list items in saved
class FoodListCard extends StatelessWidget {
  final ImageProvider<Object> listImage;
  final String listTitle;
  final String listCuisine;
  final int listDollars;
  final double listDistance;
  const FoodListCard({
    super.key,
    required this.listImage,
    required this.listTitle,
    required this.listCuisine,
    required this.listDollars,
    required this.listDistance,
  });

  @override
  Widget build(BuildContext context) {
    // Card item
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Tappable portion of card
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // Display image based on availability of user uploaded image
                      image: listImage,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(listTitle,
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              fontSize: 16.0,
                            )),
                    const SizedBox(height: 5.0),
                    Row(children: [
                      Text(listCuisine,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 14.0)),
                      horizontalTextDivider(context),
                      Text('\$' * listDollars,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 14.0)),
                      horizontalTextDivider(context),
                      Text("$listDistance mi",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 14.0)),
                    ]),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            // Display image based on availability of user uploaded image
                            image: AssetImage('lib/assets/instagram.png'),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            // Display image based on availability of user uploaded image
                            image: AssetImage('lib/assets/inbox.png'),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget horizontalTextDivider(BuildContext context) {
    return Text(" - ",
        style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14.0));
  }
}
