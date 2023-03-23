import 'restaurant.dart';

class Event {
  String eventId;
  String eventName;
  String bio;
  String cuisine;
  String eventLogoRef;
  String eventCoverRef;
  String restaurantName;
  int pricing;
  PopUpLocation upcomingLocation;
  String? website;
  String? instagramHandle;
  String? email;
  Event({
    required this.eventId,
    required this.eventName,
    required this.eventLogoRef,
    required this.eventCoverRef,
    required this.restaurantName,
    required this.pricing,
    required this.bio,
    required this.cuisine,
    required this.upcomingLocation,
    this.website,
    this.instagramHandle,
    this.email,
  });
}
