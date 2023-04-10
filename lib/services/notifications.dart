import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'services.dart';

class NotificationsServiceApp extends NotificationsService {
  @pragma('vm:entry-point')
  @override
  Future<void> handleInAppMessage(
      RemoteMessage message, BuildContext context) async {
    // Display in-app message using custom
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message.notification?.title ?? ""),
          content: Text(message.notification?.body ?? ""),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                FirebaseMessaging.instance
                    .subscribeToTopic(message.data["event_name"]);
                Navigator.pop(context);
              },
              child: const Text('Notify me!'),
            ),
          ],
        );
      },
    );
  }
}
