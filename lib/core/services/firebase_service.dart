import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'local_notification_service.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Flutter Web tidak memakai Firebase Messaging Android
    if (kIsWeb) {
      debugPrint("Firebase Messaging dilewati pada Web");
      return;
    }

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await _messaging.getToken();

    debugPrint("==============================");
    debugPrint("FCM TOKEN");
    debugPrint(token);
    debugPrint("==============================");

    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint("====================================");
      debugPrint("FCM FOREGROUND MESSAGE");
      debugPrint("TITLE : ${message.notification?.title}");
      debugPrint("BODY  : ${message.notification?.body}");
      debugPrint("====================================");

      await LocalNotificationService.instance.show(
        title: message.notification?.title ?? "E-Bus",
        body: message.notification?.body ?? "",
      );
    });
  }
}
