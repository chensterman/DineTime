import 'package:flutter/material.dart';

// Cards that display list items in saved
class ListCard extends StatelessWidget {
  final ImageProvider<Object>? listImage;
  final String listTitle;
  final int listNumItems;
  final DateTime? listCreateDate;
  final Function()? onTap;
  const ListCard({
    super.key,
    this.listImage,
    required this.listTitle,
    required this.listNumItems,
    this.listCreateDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the time difference from creation date if exists
    int difference = 0;
    if (listCreateDate != null) {
      final now = DateTime.now();
      difference = now.difference(listCreateDate!).inDays;
    }
    // Card item
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Tappable portion of card
      child: InkWell(
        onTap: onTap,
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
                      image: listImage != null
                          ? listImage!
                          : const AssetImage('lib/assets/dinetime-orange.png'),
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
                              fontSize: 20.0,
                            )),
                    const SizedBox(height: 5.0),
                    Row(children: [
                      Text("$listNumItems Items",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(fontSize: 14.0)),
                      if (listCreateDate != null)
                        Text("  -  ",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(fontSize: 14.0)),
                      if (listCreateDate != null)
                        Text("Created $difference days ago",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(fontSize: 14.0)),
                    ]),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
