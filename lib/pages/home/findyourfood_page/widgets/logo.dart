import 'package:dinetime_mobile_mvp/designsystem.dart';
import 'package:dinetime_mobile_mvp/services/storage.dart';
import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  final String restaurantLogoRef;
  final StorageService clientStorage;
  const Logo({
    Key? key,
    required this.restaurantLogoRef,
    required this.clientStorage,
  }) : super(key: key);

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  // Create an instance variable.
  late final Future<ImageProvider<Object>?> _getPhoto;

  @override
  void initState() {
    super.initState();

    // Assign that variable your Future.
    _getPhoto = widget.clientStorage.getPhoto(widget.restaurantLogoRef);
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
            return LogoDisplay(
                width: 60.0, height: 60.0, image: snapshot.data!);
            // On loading
          } else {
            return const LogoDisplay(
              width: 60.0,
              height: 60.0,
              isLoading: true,
            );
          }
        });
  }
}
