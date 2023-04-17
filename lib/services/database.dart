import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinetime_mobile_mvp/models/customer.dart';
import 'package:dinetime_mobile_mvp/models/owner.dart';
import 'package:dinetime_mobile_mvp/models/restaurant.dart' as r;
import 'package:dinetime_mobile_mvp/models/event.dart' as e;
import 'package:dinetime_mobile_mvp/models/restaurant.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'services.dart';

// Contains all methods and data pertaining to the user database
class DatabaseServiceApp extends DatabaseService {
  // Access to 'customers' collection
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customers');
  // Access to 'owners' collection
  final CollectionReference ownerCollection =
      FirebaseFirestore.instance.collection('owners');
  // Access to 'restaurants' collection
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');
  // Access to 'preorders' collection
  final CollectionReference preordersCollection =
      FirebaseFirestore.instance.collection('preorders');
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<bool> isCustomerUser(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('customers').doc(uid).get();
    return snapshot.exists;
  }

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

  // Delete customer in database
  @override
  Future<void> customerDelete(String customerId) async {
    await customerCollection.doc(customerId).delete();
  }

  // Get customer data
  @override
  Future<Customer?> customerGet(String customerId) async {
    DocumentSnapshot snapshot = await customerCollection.doc(customerId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Customer(
        customerId: snapshot.id,
        geolocation: data['geolocation'],
      );
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

  // Stream of specific customer favorites
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

  // Stream of all restaurants
  @override
  Stream<List<r.Restaurant>> customerAllStream() async* {
    Stream<QuerySnapshot> customerAllStream = restaurantCollection.snapshots();
    await for (QuerySnapshot querySnapshot in customerAllStream) {
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

  // Stream of specific customer preorders
  @override
  Stream<List<r.PreorderBag>> customerPreordersStream(
      String customerId) async* {
    Stream<QuerySnapshot> customerPreordersStream = preordersCollection
        .where('customer_ref', isEqualTo: customerCollection.doc(customerId))
        .snapshots();
    await for (QuerySnapshot querySnapshot in customerPreordersStream) {
      List<r.PreorderBag> preorderBagList = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        r.PreorderBag? preorderBag = await preorderGet(documentSnapshot.id);
        preorderBagList.add(preorderBag!);
        preorderBagList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      yield preorderBagList;
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
    QuerySnapshot restaurantQuery =
        await restaurantCollection.where('displayed', isEqualTo: true).get();
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

  // Get owner data
  @override
  Future<Owner?> ownerGet(String ownerId) async {
    DocumentSnapshot snapshot = await ownerCollection.doc(ownerId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<r.Restaurant> restaurants = [];
      for (DocumentReference restaurantRef in data['restaurant_refs']) {
        r.Restaurant? restaurant = await restaurantGet(restaurantRef.id);
        restaurants.add(restaurant!);
      }
      return Owner(
        ownerId: ownerId,
        restaurants: restaurants,
      );
    } else {
      return null;
    }
  }

  @override
  Stream<List<e.Event>> eventStream(String customerId) async* {
    // Implement
    List<e.Event> eventList = [];
    yield eventList;
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
      String restaurantCoverRef = restaurantData['cover_location'];
      String bio = restaurantData['restaurant_bio'];
      String cuisine = restaurantData['cuisine'];
      bool preordersEnabled = restaurantData['preorders_enabled'];
      bool displayed = restaurantData['displayed'];
      String website = restaurantData['website'];
      String instagramHandle = restaurantData['instagram_handle'];
      String email = restaurantData['email'];
      // Get restaurant gallery
      List<r.GalleryImage> gallery = [];
      QuerySnapshot galleryQuery = await restaurantCollection
          .doc(restaurantId)
          .collection("gallery")
          .orderBy("timestamp")
          .get();
      for (DocumentSnapshot doc in galleryQuery.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        gallery.add(
          r.GalleryImage(
            imageId: doc.id,
            imageName: data["image_name"],
            imageRef: data["image_ref"],
            imageDescription: data["image_desc"],
            timestamp: data["timestamp"],
          ),
        );
      }
      gallery.add(
        r.GalleryImage(
          imageId: "cover",
          imageName: "Cover Photo",
          imageRef: restaurantCoverRef,
          imageDescription: "",
          timestamp: Timestamp.now(),
        ),
      );
      // Get restaurant menu
      List<r.MenuItem> menu = [];
      QuerySnapshot menuQuery = await restaurantCollection
          .doc(restaurantId)
          .collection("menu")
          .orderBy("timestamp")
          .get();
      for (DocumentSnapshot doc in menuQuery.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        menu.add(r.MenuItem(
          timestamp: data["timestamp"],
          dietaryTags: data["dietary_tags"],
          itemDescription: data['item_desc'],
          itemId: doc.id,
          itemName: data["item_name"],
          itemPrice: data["item_price"],
          itemImageRef: data["item_image_ref"],
        ));
        // Add menu photos to gallery
        gallery.add(
          r.GalleryImage(
            imageId: doc.id,
            imageName: data["item_name"],
            imageRef: data["item_image_ref"],
            imageDescription: data["item_desc"],
            timestamp: data["timestamp"],
          ),
        );
      }
      // Get restaurant lcoations
      List<r.PopUpLocation> upcomingLocations = [];
      DateTime now = DateTime.now();
      DateTime lastMidnight = DateTime(now.year, now.month, now.day);
      QuerySnapshot locationsQuery = await restaurantCollection
          .doc(restaurantId)
          .collection("locations")
          .where("location_date_start",
              isGreaterThan: Timestamp.fromDate(lastMidnight))
          .orderBy("location_date_start")
          .get();
      for (DocumentSnapshot doc in locationsQuery.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        upcomingLocations.add(
          r.PopUpLocation(
            locationId: doc.id,
            locationAddress: data["location_address"],
            locationDateStart: data["location_date_start"],
            locationDateEnd: data["location_date_end"],
            timestamp: data["timestamp"],
            geolocation: data['geolocation'],
            locationName: data['location_name'],
          ),
        );
      }
      // Return final restaurant object
      return r.Restaurant(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        restaurantLogoRef: restaurantLogoRef,
        restaurantCoverRef: restaurantCoverRef,
        pricing: pricing,
        gallery: gallery,
        menu: menu,
        instagramHandle: instagramHandle,
        upcomingLocations: upcomingLocations,
        cuisine: cuisine,
        preordersEnabled: preordersEnabled,
        displayed: displayed,
        bio: bio,
        website: website,
        email: email,
      );
    }
  }

  @override
  Future<File> restaurantCoverPhotoGet(String restaurantId) async {
    DocumentSnapshot doc = await restaurantCollection.doc(restaurantId).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final fileBytes = await storage.ref(data["cover_location"]).getData();
    File coverPhoto = File.fromRawPath(fileBytes!);
    return coverPhoto;
  }

  @override
  Future<Map<String, File>> restaurantGalleryGet(String restaurantId) async {
    var ref = await restaurantCollection
        .doc(restaurantId)
        .collection("gallery")
        .get();
    Map<String, File> gallery = <String, File>{};
    for (DocumentSnapshot doc in ref.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final fileBytes = await storage.ref(data["image_ref"]).getData();
      File galleryPhoto = File.fromRawPath(fileBytes!);
      gallery[doc.id] = galleryPhoto;
    }
    return gallery;
  }

  @override
  Future<r.MenuItem?> restaurantMenuItemGet(
      String restaurantId, String itemId) async {
    DocumentSnapshot doc = await restaurantCollection
        .doc(restaurantId)
        .collection("menu")
        .doc(itemId)
        .get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return r.MenuItem(
      itemId: itemId,
      itemName: data["item_name"],
      itemPrice: data["item_price"],
      timestamp: data["timestamp"],
      dietaryTags: data["dietary_tags"],
      itemImageRef: data["item_image_ref"],
      itemDescription: data["item_desc"],
    );
  }

  @override
  Future<r.PopUpLocation?> restaurantLocationGet(
      String restaurantId, String locationId) async {
    DocumentSnapshot doc = await restaurantCollection
        .doc(restaurantId)
        .collection("locations")
        .doc(locationId)
        .get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return r.PopUpLocation(
      locationId: locationId,
      locationAddress: data["location_address"],
      locationDateStart: data["location_date_start"],
      locationDateEnd: data["location_date_end"],
      timestamp: data["timestamp"],
      geolocation: data["geolocation"],
      locationName: data["location_name"],
    );
  }

  // Stream of specific customer preorders
  @override
  Stream<List<r.PreorderBag>> restaurantPreordersStream(
    String restaurantId,
    bool fulfilled,
  ) async* {
    Stream<QuerySnapshot> restaurantPreordersStream = preordersCollection
        .where(
          'restaurant_ref',
          isEqualTo: restaurantCollection.doc(restaurantId),
        )
        .where(
          'fulfilled',
          isEqualTo: fulfilled,
        )
        .snapshots();
    await for (QuerySnapshot querySnapshot in restaurantPreordersStream) {
      List<r.PreorderBag> preorderBagList = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        r.PreorderBag? preorderBag = await preorderGet(documentSnapshot.id);
        preorderBagList.add(preorderBag!);
        preorderBagList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      yield preorderBagList;
    }
  }

  @override
  Future<void> restaurantUpdate(
    r.Restaurant updateFields,
    String restaurantId,
    Map<String, File?>? galleryPhotos,
    Map<String, File?>? menuPhotos,
    File? coverPhoto,
  ) async {
    // Requires that file list be in the same order as updateFields's galleryImage list
    Map<String, dynamic> updateValue = <String, dynamic>{};
    updateValue["restaurant_name"] = updateFields.restaurantName;
    updateValue["pricing"] = updateFields.pricing;
    updateValue["cuisine"] = updateFields.cuisine;
    updateValue["restaurant_bio"] = updateFields.bio;
    if (updateFields.displayed != null) {
      updateValue["displayed"] = updateFields.displayed;
    }
    if (updateFields.email != null) {
      updateValue["email"] = updateFields.email;
    }
    if (updateFields.phoneNumber != null) {
      updateValue["phone_number"] = updateFields.phoneNumber;
    }
    // Delete existing cover photo, add new one if given new photo

    DocumentSnapshot doc = await restaurantCollection.doc(restaurantId).get();
    var data = doc.data() as Map<String, dynamic>;
    if (data["image_ref"] != updateValue["image_ref"]) {
      await storage.ref(doc["image_ref"]).delete();
      updateValue["image_ref"] = "";
      if (coverPhoto != null) {
        updateValue["image_ref"] = updateFields.restaurantCoverRef;
        if (updateValue["image_ref"] != "") {
          await storage.ref(updateValue["image_ref"]).putFile(coverPhoto);
        }
      }
    }
    await restaurantCollection
        .doc(restaurantId)
        .update({updateValue} as Map<String, dynamic>);

    // To understand image updates: the protocol being used here is
    // if the image is present in the map of images, then reupload image and update fields
    // else if the the image is null and present in the map of images, then delete the image
    // else if the image is not present in the map of images, only update fields
    for (GalleryImage imageData in updateFields.gallery) {
      DocumentReference ref = restaurantCollection
          .doc(restaurantId)
          .collection("gallery")
          .doc(imageData.imageId);
      ref.set({
        "image_ref": imageData.imageRef,
        "image_name": imageData.imageName,
        "image_desc": imageData.imageDescription,
        "image_timestamp": Timestamp.now()
      });
      if (galleryPhotos != null) {
        File? upload = galleryPhotos[imageData.imageId];
        if (upload != null) {
          await storage.ref(imageData.imageRef).putFile(upload);
          // Deletion case since upload is null but its key is in the galleryPhotos
        } else if (galleryPhotos.containsKey(imageData.imageId)) {
          ref.delete();
          await storage.ref(imageData.imageRef).delete();
        }
      }
    }
    // Same protocol as above except we don't delete the menu item if image is deleted

    for (MenuItem item in updateFields.menu) {
      DocumentReference ref = restaurantCollection
          .doc(restaurantId)
          .collection("menu")
          .doc(item.itemId);
      ref.set({
        "item_desc": item.itemDescription,
        "item_image_ref": item.itemImageRef,
        "item_name": item.itemName,
        "item_price": item.itemPrice,
        "timestamp": Timestamp.now(),
        "dietary_tags": item.dietaryTags
      });
      if (menuPhotos != null) {
        File? upload = menuPhotos[item.itemId];
        if (upload != null) {
          await storage.ref(item.itemImageRef).putFile(upload);
        } else if (menuPhotos.containsKey(item.itemId)) {
          await storage.ref(item.itemImageRef).delete();
        }
      }
    }
    for (PopUpLocation location in updateFields.upcomingLocations) {
      DocumentReference ref = restaurantCollection
          .doc(restaurantId)
          .collection("menu")
          .doc(location.locationId);
      ref.set({
        "location_address": location.locationAddress,
        "location_date_start": location.locationDateStart,
        "location_name": location.locationName,
        "timestamp": Timestamp.now(),
        "geolocation": location.geolocation,
      });
      if (location.locationDateEnd != null) {
        ref.set({
          "location_date_end": location.locationDateEnd,
        });
      }
    }
  }

  @override
  Future<void> preorderCreate(String customerId, String customerEmail,
      r.PreorderBag preorderBag) async {
    String restaurantId = preorderBag.restaurant.restaurantId;
    DocumentReference newPreorder = preordersCollection.doc();
    newPreorder.set({
      "order_code": newPreorder.id.substring(0, 5).toUpperCase(),
      "customer_ref": customerCollection.doc(customerId),
      "customer_email": customerEmail,
      "restaurant_ref": restaurantCollection.doc(restaurantId),
      "location_ref": restaurantCollection
          .doc(restaurantId)
          .collection("locations")
          .doc(preorderBag.location.locationId),
      "fulfilled": false,
      "timestamp": Timestamp.now(),
    });
    for (r.PreorderItem? preorderItem in preorderBag.bag) {
      newPreorder.collection("items").doc().set({
        "menu_item_ref": restaurantCollection
            .doc(restaurantId)
            .collection("menu")
            .doc(preorderItem!.item.itemId),
        "quantity": preorderItem.quantity,
      });
    }
  }

  @override
  Future<r.PreorderBag?> preorderGet(String preorderId) async {
    DocumentSnapshot preorderSnapshot =
        await preordersCollection.doc(preorderId).get();
    if (!preorderSnapshot.exists) {
      return null;
    } else {
      // Get initial restaurant information
      Map<String, dynamic> preorderData =
          preorderSnapshot.data() as Map<String, dynamic>;
      r.Restaurant? restaurant =
          await restaurantGet(preorderData["restaurant_ref"].id);
      r.PopUpLocation? location = await restaurantLocationGet(
          restaurant!.restaurantId, preorderData["location_ref"].id);
      r.PreorderBag preorderBag = r.PreorderBag(
        preorderId: preorderId,
        customerEmail: preorderData["customer_email"],
        restaurant: restaurant,
        location: location!,
        timestamp: preorderData["timestamp"],
        fulfilled: preorderData["fulfilled"],
      );
      List<r.PreorderItem?> bag = [];
      QuerySnapshot itemsQuery =
          await preordersCollection.doc(preorderId).collection("items").get();
      for (DocumentSnapshot doc in itemsQuery.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        r.MenuItem? item = await restaurantMenuItemGet(
            preorderData["restaurant_ref"].id, data["menu_item_ref"].id);
        bag.add(r.PreorderItem(item: item!, quantity: data["quantity"]));
      }

      for (r.PreorderItem? preorderItem in bag) {
        preorderBag.updateBag(preorderItem!);
      }

      return preorderBag;
    }
  }

  @override
  Future<void> preorderUpdate(String preorderId, bool fulfilled) async {
    await preordersCollection.doc(preorderId).update({
      'fulfilled': fulfilled,
    });
  }
}
