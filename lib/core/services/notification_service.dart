import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();

  NotificationService._();

  Future<void> initialize() async {
    debugPrint("==============================");
    debugPrint("Notification Service Ready");
    debugPrint("==============================");
  }
}
