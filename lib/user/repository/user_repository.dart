import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {

  return UserRepository();
});

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 파이어베이스 인증 및 로그인 처리
  Future<Map<String, dynamic>?> fireBaseAuth({required UserCredential credential}) async {

    debugPrint("OAuthLogin :: ");
    // 데이터 유효성 검사 : idToken
    if(credential.user == null || credential.user!.uid.isEmpty) {
      debugPrint("user login error : ");
      return null;
    }

    Map<String, dynamic>? userData;

    // DB에서 유저 정보 조회
    await _firestore.collection("user").doc("google_oauth_${credential.user!.uid}").get()
        .then((result) async => {
      userData = result.data(),
      debugPrint("OAuthLogin :: search in firestore : ${userData}"),

      // 파이어베이스 Authentication에서 등록된 인증 계정 정보가 없으면 (최초 로그인 시)
      if(userData == null) {
        Join(joinType: JOIN_TYPE.GOOGLE_OAUTH, uid: credential.user!.uid, credential: credential),

        // 새로 등록한 유저 정보 다시 조회
        await _firestore.collection("user").doc("google_oauth_${credential.user!.uid}").get()
            .then((value) => userData = value.data())
      }
    });

    // userData의 applyState가 approve이면 auth 업데이트
    if(userData?["businessAuth"]?["applyState"] == "approve") {
      userData?["auth"] = "business";

      _firestore.collection("user").doc("google_oauth_${credential.user!.uid}").update(
        {"auth": userData?["auth"]}
      );
    }

    return userData;
  }

  Future<void> Join({required JOIN_TYPE joinType, required UserCredential credential, String? uid, String? userId, String? userPassword}) async {
    debugPrint("OAuthJoin :: ");
    try {
      Map<String, dynamic> userMap;

      if(uid != null) {
        userMap = {
          "userModelId": credential.user?.uid,
          "id": null,
          "password": null,
          "email": credential.user?.email,
          "displayName": credential.user?.displayName,
          "phoneNumber": credential.user?.phoneNumber,
          "photoUrl": credential.user?.photoURL,
          "joinType": joinType.name.toString(),
          "auth": "user",
        };
        await _firestore.collection("user").doc("${joinType.name.toLowerCase()}_${uid}")
          .set(userMap);

      } else {
        userMap = {
          "userModelId": credential.user?.uid,
          "id": null,
          "password": null,
          "email": credential.user?.email,
          "displayName": credential.user?.displayName,
          "phoneNumber": credential.user?.phoneNumber,
          "photoUrl": credential.user?.photoURL,
          "joinType": joinType.name.toString(),
          "auth": "user",
        };

        UserModel.fromJson(userMap);

        await _firestore.collection("user").add(
          userMap
        );
      }

    } catch(exception) {
      debugPrint('User Join Error : ${exception}');
    }
  }

  Future<Map<String, dynamic>?> getBusinessModel({required String? businessNumber, required String? uId}) async {
    _firestore.collection("user")
      .where("businessNumber", isEqualTo:businessNumber)
      .get();
  }

  // todo: 계정의 auth 업데이트 (firebaseAuth에서 사용한 것 여기서 구현)
  // Future<void> updateAuth(String? uid, String auth) async {
  //   await _firestore.collection("user").doc(uid).update(
  //       {"auth": auth}
  //   );
  // }

}
