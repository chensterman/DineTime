import 'dart:math';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:dinetime_mobile_mvp/services/database.dart';
import 'package:dinetime_mobile_mvp/services/analytics.dart';
import 'package:flutter/material.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<Restaurant> get restaurants => _restaurants;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  String customerId;
  CardProvider({required this.customerId}) {
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

  void endPosition(String restaurantId) {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.like:
        // Add analytics code here
        Analytics().getInstance().logEvent(name: "like_restaurant");
        DatabaseService().addCustomerSaved(customerId, restaurantId);
        like();
        break;
      case CardStatus.dislike:
        Analytics().getInstance().logEvent(name: "dislike_restaurant");
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
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;

    if (force) {
      const delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    } else {
      const delta = 20;

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
    if (_restaurants.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _restaurants.removeLast();
    resetPosition();
  }

  Future resetUsers() async {
    _restaurants = await DatabaseService().getRestaurantsSwipe(customerId);

    notifyListeners();
  }
}
