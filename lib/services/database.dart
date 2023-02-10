import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:dinetime_mobile_mvp/services/location.dart';

// Contains all methods and data pertaining to the user database
class DatabaseService {
  // Access to 'restaurants' collection
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');
  // Access to 'customers' collection
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customers');

  /* CUSTOMER FIRESTORE INTERACTIONS */

  // Add user document to 'users' collection and initialize fields
  Future<void> createCustomer(String customerId) async {
    await customerCollection.doc(customerId).set({
      'geolocation': null,
      'saved_businesses': [],
    });
  }

  // Update user data
  Future<void> updateCustomer(
      String customerId, Map<String, dynamic> customerData) async {
    await customerCollection.doc(customerId).update(customerData);
  }

  // Add saved restaurant to customer
  Future<void> addCustomerSaved(String customerId, String restaurantId) async {
    await customerCollection.doc(customerId).update({
      'saved_businesses': FieldValue.arrayUnion([
        {'restaurant_ref': restaurantCollection.doc(restaurantId)}
      ])
    });
  }

  // Delete saved restaurant from customer
  Future<void> deleteCustomerSaved(
      String customerId, String restaurantId) async {
    await customerCollection.doc(customerId).update({
      'saved_businesses': FieldValue.arrayRemove([
        {'restaurant_ref': restaurantCollection.doc(restaurantId)}
      ])
    });
  }

  Future<String?> customerLocationAddress(String customerId) async {
    DocumentSnapshot customerDoc =
        await customerCollection.doc(customerId).get();
    Map<String, dynamic> customerData =
        customerDoc.data() as Map<String, dynamic>;
    GeoPoint customerLocation = customerData['geolocation'];

    String? address =
        await LocationService().geopointToAddress(customerLocation);
    return address;
  }

  // Stream of specific customer document
  Stream<DocumentSnapshot> customerStream(String customerId) {
    return customerCollection.doc(customerId).snapshots();
  }

  /* RESTAURANT FIRESTORE INTERACTIONS */

  // Retrieves a data from a restaurant to obtain a RestaurantPreview object
  Future<r.RestaurantPreview> getRestaurantPreview(
      String restaurantId, String customerId) async {
    DocumentSnapshot customerDoc =
        await customerCollection.doc(customerId).get();
    Map<String, dynamic> customerData =
        customerDoc.data() as Map<String, dynamic>;
    GeoPoint customerLocation = customerData['geolocation'];

    // Retrieve restaurant document data
    DocumentSnapshot restaurantSnapshot =
        await restaurantCollection.doc(restaurantId).get();
    Map<String, dynamic> restaurantData =
        restaurantSnapshot.data() as Map<String, dynamic>;
    // Isolate all fields
    String restaurantName = restaurantData['restaurant_name'];
    String restaurantLogoRef = restaurantData['logo_location'];
    List restaurantLocationDataRaw = restaurantData['upcoming_locations'];
    int pricing = restaurantData['pricing'];
    String cuisine = restaurantData['cuisine'];
    String? instagramHandle = restaurantData['instagram_handle'];
    String? email = restaurantData['email'];
    String? website = restaurantData['website'];

    // Refactor location data into a list of PopUpLocation objects
    List<r.PopUpLocation> restaurantLocationData = [];
    if (restaurantLocationDataRaw.isNotEmpty) {
      for (Object location in restaurantLocationDataRaw) {
        Map<String, dynamic> locationMap = location as Map<String, dynamic>;
        num? distance = LocationService()
            .distanceBetweenTwoPoints(location['geocode'], customerLocation);
        restaurantLocationData.add(r.PopUpLocation(
            locationId: locationMap['location_id'],
            locationAddress: locationMap['address'],
            locationDateStart: locationMap['date_start'],
            locationDateEnd: locationMap['date_end'],
            dateAdded: locationMap['date_added'],
            geocode: locationMap['geocode'],
            name: locationMap['name'],
            distance: distance));
      }
    }

    num? distance;
    if (restaurantLocationData.isNotEmpty) {
      distance = LocationService().distanceBetweenTwoPoints(
          restaurantLocationData[0].geocode, customerLocation);
    }

    // Construct and return RestaurantPreview object
    return r.RestaurantPreview(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantLogoRef: restaurantLogoRef,
      upcomingLocations: restaurantLocationData,
      pricing: pricing,
      cuisine: cuisine,
      instagramHandle: instagramHandle,
      email: email,
      website: website,
      distance: distance,
    );
  }

  Future<r.Restaurant> getRestaurant(
      String restaurantId, String customerId) async {
    DocumentSnapshot customerDoc =
        await customerCollection.doc(customerId).get();
    Map<String, dynamic> customerData =
        customerDoc.data() as Map<String, dynamic>;
    GeoPoint customerLocation = customerData['geolocation'];

    DocumentSnapshot restaurantSnapshot =
        await restaurantCollection.doc(restaurantId).get();
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
      num? distance = LocationService()
          .distanceBetweenTwoPoints(locationRaw['geocode'], customerLocation);
      upcomingLocations.add(
        r.PopUpLocation(
          locationId: locationRaw['location_id'],
          locationAddress: locationRaw['address'],
          locationDateStart: locationRaw['date_start'],
          locationDateEnd: locationRaw['date_end'],
          dateAdded: locationRaw['date_added'],
          geocode: locationRaw['geocode'],
          name: locationRaw['name'],
          distance: distance,
        ),
      );
    }

    num? distance;
    if (upcomingLocations.isNotEmpty) {
      distance = LocationService().distanceBetweenTwoPoints(
          upcomingLocations[0].geocode, customerLocation);
    }

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
        distance: distance);
  }

  Future<List<r.Restaurant>> getRestaurantsSwipe(String customerId) async {
    // Get saved business document references from customer
    DocumentSnapshot customerDoc =
        await customerCollection.doc(customerId).get();
    Map<String, dynamic> customerData =
        customerDoc.data() as Map<String, dynamic>;
    List customerSavedRaw = customerData['saved_businesses'];
    Set savedRefSet =
        customerSavedRaw.map((e) => e['restaurant_ref'].id).toSet();

    // Get all restaurants and filter on what has already been saved by customer
    QuerySnapshot restaurantQuery = await restaurantCollection.get();
    List<DocumentSnapshot> restaurantDocs = restaurantQuery.docs;
    restaurantDocs = restaurantDocs
        .where((snapshot) => !savedRefSet.contains(snapshot.id))
        .toList();

    // Convert all remaining restaurant snapshots into list of Restaurant objects
    List<r.Restaurant> restaurantList = [];
    for (DocumentSnapshot snapshot in restaurantDocs) {
      r.Restaurant restaurant = await getRestaurant(snapshot.id, customerId);

      // Add Restaurant object to list
      restaurantList.add(restaurant);
    }

    restaurantDocs.map((snapshot) {}).toList();
    return restaurantList;
  }
}
