import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:dinetime_mobile_mvp/provider/card_provider.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/menu.dart';
import 'package:dinetime_mobile_mvp/views/tinderwidgets/additionalwidgets/photowindow.dart';

class PhotoGallery extends StatelessWidget {
  final String photo1;
  final String photo2;
  final String photo3;

  PhotoGallery({
    super.key,
    required this.photo1,
    required this.photo2,
    required this.photo3,
  });

  List<List<String>> imagePathsAndTitles = [
    [
      "/Users/jaypalamand/Dinetime/dinetime_mobile_mvp_jay/lib/assets/hamburger.png",
      "Hamburger"
    ],
    [
      "/Users/jaypalamand/Dinetime/dinetime_mobile_mvp_jay/lib/assets/biriyani.png",
      "Biriyani"
    ],
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo Gallery',
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontFamily: 'Lato',
              ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final width = MediaQuery.of(context).size.width;
            final height = MediaQuery.of(context).size.height;
            return const SizedBox(height: 20);
          },
        ),
        Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                    image: AssetImage(photo1), fit: BoxFit.cover, opacity: 0.8),
              ),
            ),
            SizedBox(width: 25),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                    image: AssetImage(photo2), fit: BoxFit.cover, opacity: 0.8),
              ),
            ),
            SizedBox(width: 25),
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
                        padding: EdgeInsets.all(25),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      const Image(
                                          image: AssetImage(
                                              'lib/assets/back_arrow.png'),
                                          height: 15,
                                          width: 15),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Go Back",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.copyWith(
                                                fontSize: 15.0,
                                                fontFamily: 'Lato',
                                                color: dineTimeColorScheme
                                                    .primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Column(
                                  children: [
                                    PhotoCarousel(
                                      imagePathsAndTitles: imagePathsAndTitles,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.5),
                  image: DecorationImage(
                      image: AssetImage(photo3),
                      fit: BoxFit.cover,
                      opacity: 0.8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
