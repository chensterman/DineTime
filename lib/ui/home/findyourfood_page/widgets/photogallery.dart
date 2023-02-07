import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PhotoGallery extends StatelessWidget {
  final List<GalleryImage> gallery;
  const PhotoGallery({
    Key? key,
    required this.gallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> galleryChildren = [];
    List<Widget> galleryButtonChildren = [];
    num count = 0;
    final controller = PageController();
    for (GalleryImage galleryImage in gallery) {
      galleryChildren.add(
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.5),
            image: DecorationImage(
                image: galleryImage.image, fit: BoxFit.cover, opacity: 0.8),
          ),
          child: Stack(
            children: [
              Container(),
              Positioned(
                top: 5,
                right: 5,
                child: Image.asset(
                  "lib/assets/expanded.png",
                  height: 15,
                  width: 15,
                ),
              ),
            ],
          ),
        ),
      );
      count += 1;
      if (count == 3) {
        break;
      }
    }
    for (GalleryImage galleryImage in gallery) {
      galleryButtonChildren.add(
        photoOption(
          context,
          galleryImage.imageName,
          galleryImage.image,
          galleryImage.imageDescription,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo Gallery',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 15.0),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Image(
                                  image: AssetImage('lib/assets/x_button.png'),
                                  height: 25,
                                  width: 25),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Column(
                            children: [
                              Container(
                                width: 410,
                                height: 400,
                                child: PageView(
                                  controller: controller,
                                  scrollDirection: Axis.horizontal,
                                  children: galleryButtonChildren,
                                ),
                              ),
                              SmoothPageIndicator(
                                controller: controller,
                                count: galleryChildren.length,
                                effect: const SwapEffect(
                                  activeDotColor: Colors.orange,
                                  dotColor: Colors.grey,
                                  dotHeight: 5,
                                  dotWidth: 5,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: galleryChildren,
          ),
        ),
      ],
    );
  }

  Widget photoOption(
    BuildContext context,
    String imageName,
    ImageProvider<Object>? image,
    String imageDescription,
  ) {
    return Container(
      child: Column(
        children: [
          Text(
            imageName,
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.25,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                  image: image ??
                      const AssetImage("lib/assets/dinetime-orange.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              imageDescription,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontSize: 12.0,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
