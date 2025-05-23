import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class PhotoGallery extends StatelessWidget {
  final List<GalleryImage> gallery;
  final StorageService clientStorage;
  const PhotoGallery({
    Key? key,
    required this.gallery,
    required this.clientStorage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> galleryChildren = [];
    List<Widget> galleryButtonChildren = [];
    num count = 0;
    for (GalleryImage galleryImage in gallery) {
      galleryChildren.add(PhotoCard(
        imageRef: galleryImage.imageRef,
        clientStorage: clientStorage,
      ));
      count += 1;
      if (count == 3) {
        break;
      }
    }
    for (GalleryImage galleryImage in gallery) {
      galleryButtonChildren.add(
        PhotoOnGallery(
          imageName: galleryImage.imageName,
          imageRef: galleryImage.imageRef,
          imageDesc: galleryImage.imageDescription,
          clientStorage: clientStorage,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo Gallery',
          style: dineTimeTypography.headlineMedium,
        ),
        const SizedBox(height: 15.0),
        gallery.isEmpty
            ? Text(
                'No gallery images.',
                style: dineTimeTypography.bodyMedium?.copyWith(
                  color: dineTimeColorScheme.onSurface,
                ),
              )
            : Container(),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return galleryDialog(
                    context, galleryButtonChildren, galleryChildren);
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

  Widget galleryDialog(
    BuildContext context,
    List<Widget> galleryButtonChildren,
    List<Widget> galleryChildren,
  ) {
    final controller = PageController();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              SizedBox(
                height: 400.0,
                child: PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: galleryButtonChildren,
                ),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: gallery.length,
                effect: const SwapEffect(
                  activeDotColor: Colors.orange,
                  dotColor: Colors.grey,
                  dotHeight: 5,
                  dotWidth: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoCard extends StatefulWidget {
  final String imageRef;
  final StorageService clientStorage;
  const PhotoCard({
    Key? key,
    required this.imageRef,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  // Create an instance variable.
  late final Future<ImageProvider<Object>?> _getPhoto;

  @override
  void initState() {
    super.initState();

    // Assign that variable your Future.
    _getPhoto = widget.clientStorage.getPhoto(widget.imageRef);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPhoto,
      builder: ((context, AsyncSnapshot<ImageProvider<Object>?> snapshot) {
        if (snapshot.hasError) {
          return Container();
          // On success
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                  image: snapshot.data!, fit: BoxFit.cover, opacity: 0.8),
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
          );
          // On loading
        } else {
          return Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.5),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: dineTimeColorScheme.primary,
              ),
            ),
          );
        }
      }),
    );
  }
}

class PhotoOnGallery extends StatefulWidget {
  final String imageName;
  final String imageRef;
  final String imageDesc;
  final StorageService clientStorage;
  const PhotoOnGallery({
    Key? key,
    required this.imageName,
    required this.imageRef,
    required this.imageDesc,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<PhotoOnGallery> createState() => _PhotoOnGalleryState();
}

class _PhotoOnGalleryState extends State<PhotoOnGallery> {
  // Create an instance variable.
  late final Future<ImageProvider<Object>?> _getPhoto;

  @override
  void initState() {
    super.initState();

    // Assign that variable your Future.
    _getPhoto = widget.clientStorage.getPhoto(widget.imageRef);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            widget.imageName,
            style: dineTimeTypography.headlineMedium,
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.25,
            child: FutureBuilder(
              future: _getPhoto,
              builder:
                  ((context, AsyncSnapshot<ImageProvider<Object>?> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                  // On success
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.5),
                      image: DecorationImage(
                        image: snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                  // On loading
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: dineTimeColorScheme.primary,
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              widget.imageDesc,
              style: dineTimeTypography.bodyMedium?.copyWith(
                color: dineTimeColorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
