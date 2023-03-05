import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart';

class DataMock {
  final List<Restaurant> favoritedRestaurants = [
    Restaurant(
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
    ),
  ];

  final List<Restaurant> swipeRestaurants = [
    Restaurant(
      restaurantId: "1",
      restaurantName: "David Dai's",
      restaurantLogoRef: "test/images/david_dais_logo.jpeg",
      restaurantCoverRef: "test/images/gallery_image.jpeg",
      pricing: 2,
      gallery: [
        GalleryImage(
          imageId: "11",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/gallery_image.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
      ],
      menu: [
        MenuItem(
          itemId: "11",
          itemName: "Item Name",
          itemPrice: 4,
          timestamp: Timestamp.now(),
          dietaryTags: ["Vegan"],
          itemImageRef: "test/images/menu_item.jpeg",
          itemDescription:
              "This is just a test menu item. This is just a test menu item. This is just a test menu item. This is just a test menu item. This is just a test menu item.",
        ),
      ],
      upcomingLocations: [
        PopUpLocation(
          locationId: "11",
          locationAddress: "Location Address, WA 12345",
          locationDateStart: Timestamp.now(),
          locationDateEnd: null,
          timestamp: Timestamp.now(),
          geolocation: const GeoPoint(47.60, -122.33),
          locationName: "Location Name",
        ),
      ],
      bio:
          "This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio.",
      cuisine: "Chinese",
    ),
    Restaurant(
      restaurantId: "2",
      restaurantName: "Literal Dogshit",
      restaurantLogoRef: "test/images/dogshit.jpeg",
      restaurantCoverRef: "test/images/gallery_image.jpeg",
      pricing: 2,
      gallery: [
        GalleryImage(
          imageId: "21",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/gallery_image.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
        GalleryImage(
          imageId: "22",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/gallery_image.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
        GalleryImage(
          imageId: "23",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/menu_item.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
        GalleryImage(
          imageId: "23",
          imageDescription:
              "This is just a test gallery image. This is just a test gallery image. This is just a test gallery image.",
          imageRef: "test/images/dogshit.jpeg",
          timestamp: Timestamp.now(),
          imageName: "Image Name",
        ),
      ],
      menu: [
        MenuItem(
          itemId: "21",
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
          locationId: "21",
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
      cuisine: "Indian",
    ),
    Restaurant(
      restaurantId: "3",
      restaurantName: "Empty's",
      restaurantLogoRef: "test/images/dogshit.jpeg",
      restaurantCoverRef: "test/images/gallery_image.jpeg",
      pricing: 2,
      gallery: [],
      menu: [],
      upcomingLocations: [],
      bio:
          "This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio. This is a test bio.",
      cuisine: "Indian",
    ),
  ];
}
