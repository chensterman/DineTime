// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/models/user.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<User> get users => _users;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 40 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;

    if (force) {
      final delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    } else {
      final delta = 20;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard() async {
    if (users.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
  }

  void resetUsers() {
    _users = <User>[
      User(
          name: 'Canes Pop-Up Shop',
          age: 20,
          urlImage: 'lib/assets/r1.png',
          logoImage: 'lib/assets/l1.png',
          cuisine: 'Indian',
          cost: '\$',
          distance: '4.2 mi',
          location: 'Leons house',
          date: 'December 30th, 2022',
          time: '1:00 PM - 6:00 PM PST',
          about:
              'McDonalds Corporation is an American multinational fast food chain, founded in 1940 as a restaurant operated by Richard and Maurice McDonald, in San Bernardino, California, United States',
          photo1: 'lib/assets/photos.png',
          photo2: 'lib/assets/restaurant.png',
          photo3: 'lib/assets/photos.png',
          dietary1: 'Vegan',
          dietary2: 'Nut Free',
          dietary3: 'Vegetarian',
          menu1: 'Vegetable Biryani',
          menuph1: 'lib/assets/samosa.png',
          menuprice1: '9.99',
          menudesc1: 'Tasty Vegetable Biryani',
          menu2: 'Samosa',
          menuph2: 'lib/assets/samosa.png',
          menuprice2: '14.99',
          menudesc2: 'Tasty Samosas',
          upcominglocation1: 'Seattle Fremont Brewery',
          upcominglocationdate1: '11/22',
          upcominglocationdist1: '1.3 mi',
          upcominglocationtime1: '3:00 PM - 6:00 PM PST',
          upcominglocation2: 'The Food Stall',
          upcominglocationdist2: '11/24',
          upcominglocationtime2: '1.6 mi',
          upcominglocationdate2: '4:00 PM - 7:00 PM PST'),
      User(
          name: 'McDonalds Pop-Up',
          age: 21,
          urlImage: 'lib/assets/r2.png',
          logoImage: 'lib/assets/l2.png',
          cuisine: 'Indian',
          cost: '\$\$\$\$',
          distance: '1.2 mi',
          location: 'SpaceX Headquarters',
          date: 'April 20th, 2021',
          time: '4:00 PM - 7:00 PM PST',
          about:
              'Wendys Corporation is an American multinational fast food chain, founded in 1940 as a restaurant operated by Richard and Maurice McDonald, in San Bernardino, California, United States',
          photo1: 'lib/assets/photos.png',
          photo2: 'lib/assets/restaurant.png',
          photo3: 'lib/assets/photos.png',
          dietary1: 'Vegan',
          dietary2: 'Nut Free',
          dietary3: 'Vegetarian',
          menu1: 'Vegetable Biryani',
          menuph1: 'lib/assets/samosa.png',
          menuprice1: '9.99',
          menudesc1: 'Tasty Vegetable Biryani',
          menu2: 'Samosa',
          menuph2: 'lib/assets/samosa.png',
          menuprice2: '14.99',
          menudesc2: 'Tasty Samosas',
          upcominglocation1: 'Seattle Fremont Brewery',
          upcominglocationdate1: '11/22',
          upcominglocationdist1: '1.3 mi',
          upcominglocationtime1: '3:00 PM - 6:00 PM PST',
          upcominglocation2: 'The Food Stall',
          upcominglocationdist2: '11/24',
          upcominglocationtime2: '1.6 mi',
          upcominglocationdate2: '4:00 PM - 7:00 PM PST'),
      User(
          name: 'Burger King Pop-Up',
          age: 24,
          urlImage: 'lib/assets/r3.png',
          logoImage: 'lib/assets/l3.png',
          cuisine: 'Italian',
          cost: '\$\$',
          distance: '6.9 mi',
          location: 'Seattle Airport',
          date: 'March 1st, 2019',
          time: '3:00 PM - 6:00 PM PST',
          about:
              'Tinder Corporation is an American multinational fast food chain, founded in 1940 as a restaurant operated by Richard and Maurice McDonald, in San Bernardino, California, United States',
          photo1: 'lib/assets/photos.png',
          photo2: 'lib/assets/restaurant.png',
          photo3: 'lib/assets/photos.png',
          dietary1: 'Vegan',
          dietary2: 'Nut Free',
          dietary3: 'Vegetarian',
          menu1: 'Vegetable Biryani',
          menuph1: 'lib/assets/samosa.png',
          menuprice1: '9.99',
          menudesc1: 'Tasty Vegetable Biryani',
          menu2: 'Samosa',
          menuph2: 'lib/assets/samosa.png',
          menuprice2: '14.99',
          menudesc2: 'Tasty Samosas',
          upcominglocation1: 'Seattle Fremont Brewery',
          upcominglocationdate1: '11/22',
          upcominglocationdist1: '1.3 mi',
          upcominglocationtime1: '3:00 PM - 6:00 PM PST',
          upcominglocation2: 'The Food Stall',
          upcominglocationdist2: '11/24',
          upcominglocationtime2: '1.6 mi',
          upcominglocationdate2: '4:00 PM - 7:00 PM PST'),
    ].reversed.toList();

    notifyListeners();
  }
}
