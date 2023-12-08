import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';

// 전역 상태 관리
// StateNotifierProvider는 제네릭 안의 첫번째, 두번째 요소를 활용하여 상태를 관리함
// 두번째 요소가 상태를 관리할 객체이고
// 첫번째 요소는 그 객체의 필드, 메소드 등을 담은 클래스? 의 개념임
// userProvider 변수를 호출하여 전역에서 UserModel 객체를 활용할 수 있고 상태를 감지함
final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>((ref) {
  return UserStateNotifier();
});

class UserStateNotifier extends StateNotifier<UserModel?> {
  static UserStateNotifier? _instance;
  static UserStateNotifier getInstance() {
    _instance ??= UserStateNotifier();
    return _instance!;
  }


  UserStateNotifier() : super(UserModel(userModelId: "", email: "", displayName: "", phoneNumber: "", photoUrl: "")){
    _instance ??= this;
  }

  void setJoinType(JOIN_TYPE joinType) {
    state!.joinType = joinType;
  }

  void login({
    required UserCredential userCredential
  }) {
    if(userCredential == null) {
      return;
    }

    User user = userCredential.user!;

    UserModel loginUser = UserModel(
      userModelId: user.uid,
      email: user.email ?? "",
      displayName: user.displayName ?? "",
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL
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