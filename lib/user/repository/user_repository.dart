import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';

/// User 관련 DB 접근 처리 Repository
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 파이어베이스 인증 및 로그인 처리
  Future<Map<String, dynamic>?> firebaseAuth({required UserCredential credential}) async {

    debugPrint("OAuthLogin :: ");

    // 데이터 유효성 검사 : idToken
    if(credential.user == null || credential.user!.uid.isEmpty) {
      debugPrint("user login error : ");
      return null;
    }

    // 결과
    Map<String, dynamic>? result;

    // DB에서 유저 정보 조회 : 구글 로그인
    await _firestore.collection("user").doc("google_oauth_${credential.user!.uid}").get().then((value) async {
      debugPrint("OAuthLogin :: search in firestore : $result");

      if(!value.exists) { // 로그인 정보가 있는 경우
        result = value.data();
      } else {            // 로그인 정보가 없는 경우
        // 회원가입
        join(joinType: JOIN_TYPE.GOOGLE_OAUTH, uid: credential.user!.uid, credential: credential);

        // 새로 등록한 유저 정보 다시 조회
        await _firestore.collection("user").doc("google_oauth_${credential.user!.uid}").get().then((value) => result = value.data());
      }
    });

    return result;
  }

  /// 회원가입
  Future<void> join({required JOIN_TYPE joinType, required UserCredential credential, String? uid, String? id, String? password}) async {
    debugPrint("OAuthJoin :: ");

    try {
      UserModel userModel = UserModel(
        userUid: credential.user?.uid,
        id: id,
        password: password,
        email: credential.user?.email,
        displayName: credential.user?.displayName,
        phoneNumber: credential.user?.phoneNumber,
        photoUrl: credential.user?.photoURL,
        joinType: joinType,
        auth: "user",
      );

      Map<String, dynamic> userMap = userModel.toMapAll();

      if(uid != null) {   // 고정 UID가 있는 경우
        // UID 강제 입력
        userMap["userUid"] = uid;
        await _firestore.collection("user").doc("${joinType.name.toLowerCase()}_$uid").set(userMap);
      } else {            // 고정 UID가 없는 경우
        await _firestore.collection("user").add(userMap);
      }
    } catch(exception) {
      debugPrint('User Join Error : $exception');
    }
  }

  // TODO: 계정의 auth 업데이트 (firebaseAuth에서 사용한 것 여기서 구현)
  // Future<void> updateAuth(String? uid, String auth) async {
  //   await _firestore.collection("user").doc(uid).update(
  //       {"auth": auth}
  //   );
  // }

}
