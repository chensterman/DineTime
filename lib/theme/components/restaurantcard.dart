import 'package:flutter/material.dart';

// Cards that display list items in saved.
class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get size of screen
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.95;
    double height = size.height * 0.7;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: width,
        height: height,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://media-cldnry.s-nbcnews.com/image/upload/newscms/2019_21/2870431/190524-classic-american-cheeseburger-ew-207p.jpg'),
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                  Image(image: AssetImage('lib/assets/location.png')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
