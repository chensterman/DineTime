import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class PhotoCarousel extends StatefulWidget {
  final List<List<String>> imagePathsAndTitles;

  PhotoCarousel({required this.imagePathsAndTitles});

  @override
  _PhotoCarouselState createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 248,
          height: 248,
          child: CarouselSlider(
            items: List<Widget>.generate(widget.imagePathsAndTitles.length,
                (int index) {
              return Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.imagePathsAndTitles[index][1],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      widget.imagePathsAndTitles[index][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }),
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: DotsIndicator(
              dotsCount: widget.imagePathsAndTitles.length,
              position: _currentPage.toDouble(),
              decorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                color: Colors.orange,
                activeColor: Colors.white,
                spacing: const EdgeInsets.all(3.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
