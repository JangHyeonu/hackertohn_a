import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';
import 'package:seeya_hackthon_a/business/provider/business_provider.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/repository/user_repository.dart';

// 전역 상태 관리
// StateNotifierProvider는 제네릭 안의 첫번째, 두번째 요소를 활용하여 상태를 관리함
// 두번째 요소가 상태를 관리할 객체이고
// 첫번째 요소는 그 객체의 필드, 메소드 등을 담은 클래스? 의 개념임
// userProvider 변수를 호출하여 전역에서 UserModel 객체를 활용할 수 있고 상태를 감지함
final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);

  return UserStateNotifier(ref: ref, userRepository: userRepository);
});

class UserStateNotifier extends StateNotifier<UserModel?> {
  Ref? ref;
  UserRepository? userRepository;

  static UserStateNotifier? _instance;

  static UserStateNotifier getInstance2() {
    _instance ??= UserStateNotifier();
    return _instance!;
  }

  UserStateNotifier getInstance() {
    _instance ??= UserStateNotifier(ref: ref, userRepository: userRepository);
    return _instance!;
  }

  UserStateNotifier({
    this.ref,
    this.userRepository,
  }) : super(UserModel(userModelId: "", email: "", displayName: "", phoneNumber: "", photoUrl: "")){
    _instance ??= this;
  }

  void setJoinType(JOIN_TYPE joinType) {
    state?.joinType = joinType;
  }

  // 유저의 비즈니스 계정 인증 신청에 따른 상태값 변경
  void setState(String userState) {
    UserModel updatedUser = state!.copyWith(
      state: userState
    );

    state = updatedUser;
  }

  // 로그인 처리
  void login ({
    required UserCredential userCredential
  }) async {
    if(userCredential == null) {
      return;
    }

    // 파이어베이스 인증 후 user 데이터 조회
    Map<String, dynamic>? userMap = await userRepository!.fireBaseAuth(credential: userCredential);

    if(userMap == null) {
      return;
    }

    // User user = userCredential.user!;
    BusinessModel? businessAuth;

    // 해당 user의 businessAuth 데이터 조회
    businessAuth = await ref!.read(businessProvider.notifier).getBusinessAuth(userMap['userModelId']);

    // businessAuth가 승인이 나면 사업자 권한 제공
    String? auth;
    if(businessAuth?.applyState == "approve") {
      auth = "business";
    }

    // UserModel에 데이터 주입
    UserModel loginUser = UserModel(
      userModelId: userMap['userModelId'],
      email: userMap['email'],
      displayName: userMap['displayName'],
      phoneNumber: userMap['phoneNumber'],
      photoUrl: userCredential.user!.photoURL,
      businessModel: businessAuth ?? BusinessModel(),
      auth: auth,
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