
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CustomFirebaseMessaging {

  final String _serverKey = "AAAA9oRxNlk:APA91bH07a3gcw3w7l7H8DoQI3LB3RZjBYQJgSQQscGryIQ1rT2pxT0VLIcIB6ND4lgW6oCkee3N3yujEI5fgFOamgpnIV5FGKsTPXRm3p-pgFC-kOloOhj2_QUuwIpwVWMyhLHjfb7u";
  static final CustomFirebaseMessaging instance = CustomFirebaseMessaging();
  static String? myToken = "";

  // 초기 설정
  static Future<bool> init() async {
    bool result = false;

    // 권한 요청
    NotificationSettings permission = await FirebaseMessaging.instance.requestPermission();

    // 알림 거부됨
    if(permission.alert == AppleNotificationSetting.disabled) {
      debugPrint("알림이 거부되었습니다.");
      return result;
    }

    // 토큰 발급
    String? _fcmToken = await FirebaseMessaging.instance.getToken();
    myToken = _fcmToken;
    debugPrint("Firebase Messaging token : $_fcmToken");

    //
    // FirebaseMessaging.instance.subscribeToTopic("event_set");

    // 켜짐(앱 상태)시 동작
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          debugPrint(message.notification!.title);
          debugPrint(message.notification!.body);
          debugPrint(message.data["click_action"]);
        }
        Fluttertoast.showToast(msg: message.notification!.body ?? "");
      }
    });

    // 백그라운드(앱 상태)시 동작
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          debugPrint(message.notification!.title);
          debugPrint(message.notification!.body);
          debugPrint(message.data["click_action"]);
        }
      }
    });

    // 종료(앱 상태)시 동작
    FirebaseMessaging.instance.getInitialMessage()
        .then((RemoteMessage? message) {
          if (message != null) {
            if (message.notification != null) {
              debugPrint(message.notification!.title);
              debugPrint(message.notification!.body);
              debugPrint(message.data["click_action"]);
            }
          }
        }
    );

    return !result;
  }

  // PUSH 알림 발송
  void sendMessage({required String message, required List<String> toTokens}) async {

    http.Response response;

    try {
      response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey'
          },
          body: jsonEncode({
            'notification': {'title': "로컬캐치", 'body': message, 'sound': 'false'},
            'ttl': '60s',
            "content_available": true,
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "action": '테스트',
            },
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            // 'to': myToken
            'registration_ids' : toTokens,
            // 'registration_ids': tokenList
          }));
      debugPrint("~~ send message ~~");
      debugPrint("response : ${response.body}");
      debugPrint("message: $message");
      debugPrint("to list: $toTokens");
      debugPrint("~~ send message ~~");

    } catch (e) {
      debugPrint('error $e');
    }
    
  }
}