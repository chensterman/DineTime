import 'package:cloud_firestore/cloud_firestore.dart';

// Restaurant data model
class Restaurant {
  String restaurantId;
  String restaurantName;
  String bio;
  String cuisine;
  String restaurantLogoRef;
  String restaurantCoverRef;
  int pricing;
  bool? displayed;
  List<GalleryImage> gallery;
  List<MenuItem> menu;
  List<PopUpLocation> upcomingLocations;
  String? website;
  String? instagramHandle;
  String? email;
  String? phoneNumber;
  Restaurant(
      {required this.restaurantId,
      required this.restaurantName,
      required this.restaurantLogoRef,
      required this.restaurantCoverRef,
      required this.pricing,
      required this.gallery,
      required this.menu,
      required this.upcomingLocations,
      required this.bio,
      required this.cuisine,
      this.displayed,
      this.website,
      this.instagramHandle,
      this.email,
      this.phoneNumber});
  void updateEditFood(Restaurant newRestaurant, String updateType) {
    if (updateType == "cover_photo") {
      restaurantCoverRef = newRestaurant.restaurantCoverRef;
    } else if (updateType == "photo_gallery") {
      gallery = newRestaurant.gallery;
    } else if (updateType == "business_name") {
      restaurantName = newRestaurant.restaurantName;
    } else if (updateType == "price_range") {
      pricing = newRestaurant.pricing;
    } else if (updateType == "cuisine_type") {
      cuisine = newRestaurant.cuisine;
    } else if (updateType == "our_story") {
      bio = newRestaurant.bio;
    } else if (updateType == "enable_preorders") {
      displayed = newRestaurant.displayed;
    } else if (updateType == "menu_items") {
      menu = newRestaurant.menu;
    } else if (updateType == "upcoming_locations") {
      upcomingLocations = newRestaurant.upcomingLocations;
    } else if (updateType == "email") {
      email = newRestaurant.email;
    } else if (updateType == "phone_number") {
      phoneNumber = newRestaurant.phoneNumber;
    }
  }
}

// Gallery image data model for restaurants
class GalleryImage {
  String imageId;
  String imageRef;
  String imageName;
  String imageDescription;
  Timestamp timestamp;
  GalleryImage({
    required this.imageId,
    required this.imageDescription,
    required this.imageRef,
    required this.timestamp,
    required this.imageName,
  });
}

// Menu item data model for menus
class MenuItem {
  String itemId;
  String itemName;
  num itemPrice;
  Timestamp timestamp;
  List dietaryTags;
  String itemImageRef;
  String itemDescription;
  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.timestamp,
    required this.dietaryTags,
    required this.itemImageRef,
    required this.itemDescription,
  });
}

// Pop-up location data model for restaurants
class PopUpLocation {
  String locationId;
  String locationAddress;
  Timestamp locationDateStart;
  Timestamp? locationDateEnd;
  Timestamp timestamp;
  GeoPoint geolocation;
  String locationName;
  PopUpLocation({
    required this.locationId,
    required this.locationAddress,
    required this.locationDateStart,
    required this.locationDateEnd,
    required this.timestamp,
    required this.geolocation,
    required this.locationName,
  });
}

Map<String, String> dietToImagePath = {
  "Vegan": "lib/assets/vegan.png",
  "Vegetarian": "lib/assets/vegetarian.png",
  "Nut Free": "lib/assets/nut_free.png",
};

// Class defining a preorder item
class PreorderItem {
  int quantity;
  MenuItem item;
  PreorderItem({
    required this.quantity,
    required this.item,
  });

  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
  }
}

// Class defining a preorder bag
class PreorderBag {
  final String preorderId;
  final String customerEmail;
  final Restaurant restaurant;
  final PopUpLocation location;
  final Timestamp timestamp;
  final bool fulfilled;
  PreorderBag({
    required this.preorderId,
    required this.customerEmail,
    required this.restaurant,
    required this.location,
    required this.timestamp,
    required this.fulfilled,
  }) {
    preorderCode = preorderId.substring(0, 5).toUpperCase();
  }

  late String preorderCode;
  final List<PreorderItem?> bag = [];

  // Handle adding new item, deleting if 0, etc.
  void updateBag(PreorderItem preorderItem) {
    int quantity = preorderItem.quantity;
    String menuItemId = preorderItem.item.itemId;
    PreorderItem? inBag = (bag.firstWhere((it) => it!.item.itemId == menuItemId,
        orElse: () => null));

    if (inBag != null) {
      quantity == 0 ? bag.remove(inBag) : inBag.updateQuantity(quantity);
    } else {
      bag.add(preorderItem);
    }
  }

  // Calculate total cost of preorder
  num getSubtotal() {
    num subtotal = 0;
    for (PreorderItem? preorderItem in bag) {
      subtotal += preorderItem!.item.itemPrice * preorderItem.quantity;
    }
    return subtotal;
  }
}
