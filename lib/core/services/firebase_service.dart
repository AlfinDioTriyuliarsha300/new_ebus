import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Ambil token
    final token = await _messaging.getToken();

    debugPrint("==============================");
    debugPrint("FCM TOKEN");
    debugPrint(token);
    debugPrint("==============================");

    // Listener saat aplikasi sedang dibuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("====================================");
      debugPrint("FCM FOREGROUND MESSAGE");

      debugPrint("TITLE : ${message.notification?.title}");
      debugPrint("BODY  : ${message.notification?.body}");
      debugPrint("DATA  : ${message.data}");

      debugPrint("====================================");
    });
  }
}