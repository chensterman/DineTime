import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class PhotoCarousel extends StatefulWidget {
  final List<ImageProvider<Object>> images;
  final List<String> descriptions;

  const PhotoCarousel(
      {super.key, required this.images, required this.descriptions});

  @override
  _PhotoCarouselState createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: List<Widget>.generate(widget.images.length, (int index) {
            return Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.5),
                    image: DecorationImage(
                        image: widget.images[index],
                        fit: BoxFit.cover,
                        opacity: 0.8),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.descriptions[index],
                      style: dineTimeTypography.bodySmall,
                    ),
                  ),
                ),
              ],
            );
          }),
          options: CarouselOptions(
            height: 250,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DotsIndicator(
            dotsCount: widget.images.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(8.0),
              activeSize: const Size.square(8.0),
              color: dineTimeColorScheme.onSurface,
              activeColor: dineTimeColorScheme.primary,
              spacing: const EdgeInsets.all(3.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
