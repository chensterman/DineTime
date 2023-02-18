import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;

import 'services.dart';

// Contains all methods and data pertaining to the user database
class DatabaseServiceApp extends DatabaseService {
  // Access to 'restaurants' collection
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');
  // Access to 'customers' collection
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customers');

  // Add user document to 'users' collection and initialize fields
  @override
  Future<void> customerCreate(String customerId) async {
    await customerCollection.doc(customerId).set({
      'geolocation': null,
    });
  }

  // Update customer data
  @override
  Future<void> customerUpdate(
      String customerId, Map<String, dynamic> customerData) async {
    await customerCollection.doc(customerId).update(customerData);
  }

  // Get customer data
  @override
  Future<Customer?> customerGet(String customerId) async {
    DocumentSnapshot snapshot = await customerCollection.doc(customerId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Customer(
          customerId: snapshot.id, geolocation: data['geolocation']);
    } else {
      return null;
    }
  }

  // Add saved restaurant to customer
  @override
  Future<void> customerAddFavorite(
      String customerId, String restaurantId) async {
    await customerCollection
        .doc(customerId)
        .collection("favorites")
        .doc(restaurantId)
        .set({
      'timestamp': Timestamp.now(),
      'restaurant-ref': restaurantCollection.doc(restaurantId),
    });
  }

  // Delete saved restaurant from customer
  @override
  Future<void> customerDeleteFavorite(
      String customerId, String restaurantId) async {
    await customerCollection
        .doc(customerId)
        .collection("favorites")
        .doc(restaurantId)
        .delete();
  }

  // Stream of specific customer document
  @override
  Stream<List<r.Restaurant>> customerFavoritesStream(String customerId) async* {
    Stream<QuerySnapshot> customerFavoritesStream = customerCollection
        .doc(customerId)
        .collection('favorites')
        .orderBy('timestamp')
        .snapshots();
    await for (QuerySnapshot querySnapshot in customerFavoritesStream) {
      List<r.Restaurant> restaurantList = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        r.Restaurant? restaurant = await restaurantGet(documentSnapshot.id);
        if (restaurant != null) {
          restaurantList.add(restaurant);
        }
      }
      yield restaurantList;
    }
  }

  // Get list of restaurants for customer to swipe on
  @override
  Future<List<r.Restaurant>> customerSwipe(String customerId) async {
    // Get customer's current favorited restaurants
    QuerySnapshot customerFavoritesQuery =
        await customerCollection.doc(customerId).collection('favorites').get();
    List<String> customerFavoriteDocIds =
        customerFavoritesQuery.docs.map((doc) => doc.id).toList();
    // Get all restaurants and filter on what has already been saved by customer
    QuerySnapshot restaurantQuery = await restaurantCollection.get();
    List<DocumentSnapshot> restaurantDocs = restaurantQuery.docs;
    restaurantDocs = restaurantDocs
        .where((snapshot) => !customerFavoriteDocIds.contains(snapshot.id))
        .toList();
    // Convert all remaining restaurant snapshots into list of Restaurant objects
    List<r.Restaurant> restaurantList = [];
    for (DocumentSnapshot snapshot in restaurantDocs) {
      r.Restaurant? restaurant = await restaurantGet(snapshot.id);
      // Add Restaurant object to list
      if (restaurant != null) {
        restaurantList.add(restaurant);
      }
    }
    return restaurantList;
  }

  @override
  Future<r.Restaurant?> restaurantGet(String restaurantId) async {
    DocumentSnapshot restaurantSnapshot =
        await restaurantCollection.doc(restaurantId).get();
    if (!restaurantSnapshot.exists) {
      return null;
    } else {
      // Get initial restaurant information
      Map<String, dynamic> restaurantData =
          restaurantSnapshot.data() as Map<String, dynamic>;
      String restaurantName = restaurantData['restaurant_name'];
      int pricing = restaurantData['pricing'];
      String restaurantLogoRef = restaurantData['logo_location'];
      String bio = restaurantData['restaurant_bio'];
      String cuisine = restaurantData['cuisine'];
      String website = restaurantData['website'];
      String instagramHandle = restaurantData['instagram_handle'];
      String email = restaurantData['email'];
      // Get restaurant gallery
      List galleryRaw = restaurantData['gallery'];
      List<r.GalleryImage> gallery = [];
      for (Map<String, dynamic> imageRaw in galleryRaw) {
        gallery.add(r.GalleryImage(
            imageId: imageRaw['photo_id'],
            imageName: imageRaw['photo_name'],
            imageRef: imageRaw['photo_location'],
            imageDescription: imageRaw['photo_description'],
            dateAdded: imageRaw['date_added']));
      }
      // Get restaurant menu
      List menuRaw = restaurantData['menu'];
      List<r.MenuItem> menu = [];
      for (Map<String, dynamic> menuItemRaw in menuRaw) {
        menu.add(r.MenuItem(
          dateAdded: menuItemRaw['date_added'],
          dietaryTags: menuItemRaw['dietary_tags'],
          itemDescription: menuItemRaw['item_description'],
          itemId: menuItemRaw['item_id'],
          itemName: menuItemRaw['item_name'],
          itemPrice: menuItemRaw['item_price'],
          itemImageRef: menuItemRaw['photo_location'],
        ));
      }
      // Get restaurant lcoations
      List locationsRaw = restaurantData['upcoming_locations'];
      List<r.PopUpLocation> upcomingLocations = [];
      for (Map<String, dynamic> locationRaw in locationsRaw) {
        upcomingLocations.add(
          r.PopUpLocation(
            locationId: locationRaw['location_id'],
            locationAddress: locationRaw['address'],
            locationDateStart: locationRaw['date_start'],
            locationDateEnd: locationRaw['date_end'],
            dateAdded: locationRaw['date_added'],
            geocode: locationRaw['geocode'],
            name: locationRaw['name'],
          ),
        );
      }
      // Return final restaurant object
      return r.Restaurant(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        restaurantLogoRef: restaurantLogoRef,
        pricing: pricing,
        gallery: gallery,
        menu: menu,
        instagramHandle: instagramHandle,
        upcomingLocations: upcomingLocations,
        cuisine: cuisine,
        bio: bio,
        website: website,
        email: email,
      );
    }
  }
}
