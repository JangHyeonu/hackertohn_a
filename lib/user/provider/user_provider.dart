import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:seeya_hackthon_a/_common/firebse_messaging/custom_firebase_messaging.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';
import 'package:seeya_hackthon_a/business/provider/business_provider.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/repository/user_repository.dart';

/// 로그인 유저 정보 전역 관리용 Provider
final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>((ref) {
  return UserStateNotifier(UserModel(userUid: "", email: "", displayName: "", phoneNumber: "", photoUrl: ""));
});

/// 로그인 유저 정보 전역 관리용 Notifier
class UserStateNotifier extends StateNotifier<UserModel?> {
  final UserRepository? userRepository = UserRepository();

  // 싱글턴
  static UserStateNotifier? _instance;
  static UserStateNotifier getInstance() {
    return _instance!;
  }

  UserStateNotifier(super._state) {
    _instance = this;
  }

  // 유저의 비즈니스 계정 인증 신청에 따른 상태값 변경
  void setState(String userState) {
    UserModel updatedUser = state!.copyWith(
      state: userState
    );
    state = updatedUser;
  }

  // 로그인 처리
  void login ({ required UserCredential userCredential }) async {

    // 파이어베이스 인증 후 user 데이터 조회
    Map<String, dynamic>? userMap = await userRepository!.firebaseAuth(credential: userCredential);

    if(userMap == null) {
      return;
    }

    // User user = userCredential.user!;
    BusinessModel? businessAuth;

    // 해당 user의 businessAuth 데이터 조회
    businessAuth = state?.businessModel ?? BusinessModel();

    // businessAuth가 승인이 나면 사업자 권한 제공
    if(state?.businessModel?.applyState == "approve") {
      state?.auth = "business";
    }

    // UserModel에 데이터 주입
    UserModel loginUser = UserModel(
      userUid: userMap['userUid'],
      email: userMap['email'],
      displayName: userMap['displayName'],
      phoneNumber: userMap['phoneNumber'],
      photoUrl: userCredential.user!.photoURL,
      businessModel: businessAuth ?? BusinessModel(),
      auth: userMap['auth'] ?? "user",
      messagingToken: CustomFirebaseMessaging.instance.getToken() ?? userMap['messagingToken'],
    );
    
    state = loginUser;
  }

  void logout() {
    state = null;
  }

  bool isLogin() {
    if(state!.email == "") {
      return false;
    } else {
      return true;
    }
  }


}