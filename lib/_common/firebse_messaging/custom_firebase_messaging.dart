
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// Firebase Messaging
class CustomFirebaseMessaging {

  // 싱글턴
  static final CustomFirebaseMessaging instance = CustomFirebaseMessaging();
  
  // TODO :: 푸시 알림 발송 서버로 구현
  // 알림 발송용 서비스 인증키 (2024년 6월 까지만 이 방식을 지원)
  static const String _serverKey = "AAAA9oRxNlk:APA91bH07a3gcw3w7l7H8DoQI3LB3RZjBYQJgSQQscGryIQ1rT2pxT0VLIcIB6ND4lgW6oCkee3N3yujEI5fgFOamgpnIV5FGKsTPXRm3p-pgFC-kOloOhj2_QUuwIpwVWMyhLHjfb7u";

  // 기기변 메세지 수신 토큰
  static late final String? _myToken;
  String? getToken() { return _myToken; }

  // 푸시 알림 권한 요청 및 초기 설정
  static Future<bool> requestPermissionAndInit() async {
    bool result = false;

    // 권한 요청
    NotificationSettings permission = await FirebaseMessaging.instance.requestPermission();

    // 알림이 거부된 경우
    if(permission.alert == AppleNotificationSetting.disabled) {
      Fluttertoast.showToast(msg: "알림이 거부되었습니다.");
      debugPrint("알림이 거부되었습니다.");
      return result;
    }

    // 기기 토큰 가져오기
    _myToken = await FirebaseMessaging.instance.getToken();
    // debugPrint("Firebase Messaging token : $_myToken");\

    // 켜짐(앱 상태)시 동작
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      debugPrintMessage(message);
      // 알림 내용 토스트로 출력 :: 앱이 켜져있는 상태면 자동으로 알림이 알림바에 출력되지 않음
      Fluttertoast.showToast(msg: message?.notification?.body ?? "");
    });

    // 백그라운드(앱 상태)시 동작
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      debugPrintMessage(message);
    });

    // 종료(앱 상태)시 동작
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      debugPrintMessage(message);
    });

    return !result;
  }

  // PUSH 알림 발송
  void sendMessage({String? title, required String message, required List<String> targetTokenList}) async {

    http.Response response;

    try {
      response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey'
          },
          body: jsonEncode({
            'notification': {'title': title ?? "로컬캐치", 'body': message, 'sound': 'false'},
            'ttl': '60s',
            "content_available": true,
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "action": '테스트',
            },
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            // 'to': String token
            // 'registration_ids': List<String> tokenList
            'registration_ids' : targetTokenList,
          }));
    } catch (e) {
      debugPrint('error $e');
    }
    
  }

  // 디버깅용 메세지 내용 출력
  static void debugPrintMessage(RemoteMessage? message) {
    if (message != null) {
      if (message.notification != null) {
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
        debugPrint(message.data["click_action"]);
      }
    }
  }
}