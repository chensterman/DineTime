import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  final double width;
  final double height;
  final String restaurantCoverRef;
  final Services services;
  const Background({
    Key? key,
    required this.width,
    required this.height,
    required this.restaurantCoverRef,
    required this.services,
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
    _getPhoto =
        widget.services.clientStorage.getPhoto(widget.restaurantCoverRef);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
              child: Center(
                child: CircularProgressIndicator(
                  color: dineTimeColorScheme.primary,
                ),
              ),
            );
          }
        });
  }
}
