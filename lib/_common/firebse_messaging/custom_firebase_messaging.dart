

import 'package:firebase_messaging/firebase_messaging.dart';

class CustomFirebaseMessaging {

  // 권한 요청
  static Future<bool> requestGeolocatorPermission() async {
    NotificationSettings permission = await FirebaseMessaging.instance.requestPermission();

    return true;
  }
}