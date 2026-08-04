import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'local_notification_service.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Ambil token
    final token = await _messaging.getToken();

    debugPrint("==============================");
    debugPrint("FCM TOKEN");
    debugPrint(token);
    debugPrint("==============================");

    // Listener saat aplikasi sedang dibuka
    FirebaseMessaging.onMessage.listen((message) async {

      print("====================================");
      print("FCM FOREGROUND MESSAGE");
      print("TITLE : ${message.notification?.title}");
      print("BODY  : ${message.notification?.body}");
      print("====================================");

      await LocalNotificationService.instance.show(
        title:
            message.notification?.title ??
            "E-Bus",
        body:
            message.notification?.body ??
            "",
      );
    });
  }
}
