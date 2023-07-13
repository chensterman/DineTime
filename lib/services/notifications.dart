import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'services.dart';

class NotificationsServiceApp extends NotificationsService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseInAppMessaging _inAppMessaging =
      FirebaseInAppMessaging.instance;

  @override
  Future<void> handleNotifications() async {
    // Handling permissions for ios notifications
    if (Platform.isIOS) {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   print('User granted permission');
      // } else if (settings.authorizationStatus ==
      //     AuthorizationStatus.provisional) {
      //   print('User granted provisional permission');
      // } else {
      //   print('User declined or has not accepted permission');
      // }
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .update({
      'token': token,
    });
  }

  @override
  Future<void> handleToken() async {
    // Get the token each time the application loads
    String? token = await _messaging.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    _messaging.onTokenRefresh.listen(saveTokenToDatabase);
  }

  // // Initialize Firebase in-app messaging
  // _inAppMessaging.setAutomaticDataCollectionEnabled(true);
  // // Register Firebase in-app messaging callback for messages received when app is terminated
  // FirebaseMessaging.instance.getInitialMessage().then((message) {
  //   if (message != null && message.data["type"] == "event_reminder") {
  //     widget.services.clientNotifications
  //         .handleInAppMessage(message, context);
  //   }
  // });

  // // Register Firebase messaging callback for messages received when app is in the foreground or background
  // FirebaseMessaging.onMessage.listen((message) {
  //   if (message.data["type"] == "event_reminder") {
  //     widget.services.clientNotifications
  //         .handleInAppMessage(message, context);
  //   }
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   if (message.data["type"] == "event_reminder") {
  //     widget.services.clientNotifications
  //         .handleInAppMessage(message, context);
  //   }
  // });

  // @pragma('vm:entry-point')
  // @override
  // Future<void> handleInAppMessage(
  //     RemoteMessage message, BuildContext context) async {
  //   // Display in-app message using custom
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(message.notification?.title ?? ""),
  //         content: Text(message.notification?.body ?? ""),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Close'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               FirebaseMessaging.instance
  //                   .subscribeToTopic(message.data["event_name"]);
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Notify me!'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
