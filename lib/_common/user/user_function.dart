

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserFunction {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // 로그인 처리 :: 현재 google auth
  static OAuthLogin({required UserCredential credential}) async {
    debugPrint("OAuthLogin :: ");
    // 데이터 유효성 검사 : idToken
    if(credential.user == null || credential.user!.uid.isEmpty) {
      debugPrint("user login error : ");
      return null;
    }

    Map<String, dynamic>? userData;
    // DB에서 유저 정보 조회
    await _firestore.collection("user").doc("google_auth_${credential.user!.uid}").get()
        .then((result) => {
          userData = result.data(),
          debugPrint("OAuthLogin :: search in firestore : ${userData}"),
          if(userData == null) {
            Join(joinType: JOIN_TYPE.GOOGLE_OAUTH, uid: credential.user!.uid),
          }
        });
  }

  // 로그아웃
  static LogOut() {

  }

  // 회원 가입
  static Join({required JOIN_TYPE joinType, String? uid, String? userId, String? userPassword}) async {
    debugPrint("OAuthJoin :: ");
    try {
      if(uid != null) {
        await _firestore.collection("user").doc("${joinType.name.toLowerCase()}_${uid}")
            .set({
          "id":userId,
          "password":userPassword,
          "reg_type":joinType.name.toString(),
          "reg_datetime":DateTime.now(),
        });
      } else {
        await _firestore.collection("user").add({
          "id":userId,
          "password":userPassword,
          "reg_type":joinType.name.toString(),
          "reg_datetime":DateTime.now(),
        });
      }

    } catch(exception) {
      debugPrint('User Join Error : ${exception}');
    }
  }

}

enum JOIN_TYPE {
  REGIST,
  GOOGLE_OAUTH,
}