import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';

class PreordersDataMock {
  final List<PreorderBag> preorders = [];
  PreordersDataMock() {
    Restaurant restaurant = Restaurant(
      restaurantId: "0",
      restaurantName: "Steph Curry's Pop Up",
      restaurantLogoRef: "test/images/steph_curry_logo.png",
      restaurantCoverRef: "test/images/gallery_image.jpeg",
      pricing: 2,
      gallery: [
        GalleryImage(
          imageId: "01",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/gallery_image.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
      ],
      menu: [
        MenuItem(
          itemId: "01",
          itemName: "Item Name",
          itemPrice: 4,
          timestamp: Timestamp.now(),
          dietaryTags: ["Vegan"],
          itemImageRef: "test/images/menu_item.jpeg",
          itemDescription:
              "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
        ),
      ],
      upcomingLocations: [
        PopUpLocation(
          locationId: "01",
          locationAddress: "Location Address, WA 12345",
          locationDateStart: Timestamp.now(),
          locationDateEnd: Timestamp.now(),
          timestamp: Timestamp.now(),
          geolocation: const GeoPoint(47.60, -122.33),
          locationName: "Location Name",
        ),
      ],
      bio:
          "This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio.",
      cuisine: "Pastry",
    );

    MenuItem menuItem1 = MenuItem(
      itemId: "01",
      itemName: "Item Name 1",
      itemPrice: 4,
      timestamp: Timestamp.now(),
      dietaryTags: ["Vegan"],
      itemImageRef: "test/images/menu_item.jpeg",
      itemDescription:
          "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
    );
    MenuItem menuItem2 = MenuItem(
      itemId: "02",
      itemName: "Item Name 2",
      itemPrice: 4,
      timestamp: Timestamp.now(),
      dietaryTags: ["Vegan", "Nut Free"],
      itemImageRef: "test/images/menu_item.jpeg",
      itemDescription:
          "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
    );

    MenuItem menuItem3 = MenuItem(
      itemId: "03",
      itemName: "Item Name 3",
      itemPrice: 4,
      timestamp: Timestamp.now(),
      dietaryTags: [],
      itemImageRef: "test/images/menu_item.jpeg",
      itemDescription:
          "This is just a test menu item. This is just a test menu item. This is just a test menu item.",
    );

    PreorderBag bag1 = PreorderBag(
        preorderId: "ABCDE",
        restaurant: restaurant,
        location: restaurant.upcomingLocations[0],
        timestamp: Timestamp.now());
    bag1.updateBag(PreorderItem(quantity: 5, item: menuItem1));

    PreorderBag bag2 = PreorderBag(
        preorderId: "ABCDE",
        restaurant: restaurant,
        location: restaurant.upcomingLocations[0],
        timestamp: Timestamp.now());
    bag2.updateBag(PreorderItem(quantity: 1, item: menuItem1));
    bag2.updateBag(PreorderItem(quantity: 2, item: menuItem2));

    PreorderBag bag3 = PreorderBag(
        preorderId: "ABCDE",
        restaurant: restaurant,
        location: restaurant.upcomingLocations[0],
        timestamp: Timestamp.now());
    bag3.updateBag(PreorderItem(quantity: 1, item: menuItem1));
    bag3.updateBag(PreorderItem(quantity: 3, item: menuItem2));
    bag3.updateBag(PreorderItem(quantity: 2, item: menuItem3));

    preorders.addAll([bag1, bag2, bag3]);
  }
}
