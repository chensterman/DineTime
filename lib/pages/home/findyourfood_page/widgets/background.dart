import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  final double width;
  final double height;
  final List<r.MenuItem> restaurantMenu;
  final StorageService clientStorage;
  const Background({
    Key? key,
    required this.width,
    required this.height,
    required this.restaurantMenu,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  // Create an instance variable.
  late final Future<ImageProvider<Object>?> _getPhoto;

  @override
  void initState() {
    super.initState();

    // Assign that variable your Future.
    if (widget.restaurantMenu.isNotEmpty) {
      _getPhoto =
          widget.clientStorage.getPhoto(widget.restaurantMenu[0].itemImageRef);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.restaurantMenu.isEmpty
        ? Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("lib/assets/dinetime-orange.png"),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
        : FutureBuilder(
            future: _getPhoto,
            builder: (context, AsyncSnapshot<ImageProvider<Object>?> snapshot) {
              if (snapshot.hasError) {
                return Container();
                // On success
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );
                // On loading
              } else {
                return Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            });
  }
}
