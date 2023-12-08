import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

final businessProvider = StateNotifierProvider<BusinessStateNotifier, BusinessModel>((ref) {
  // 사용자의 정보를 담은 userProvider를 이용하여 UserModel 인스턴스의 상태를 관리
  final userState = ref.watch(userProvider);

  return BusinessStateNotifier(userState);
});

class BusinessStateNotifier extends StateNotifier<BusinessModel> {
  BusinessStateNotifier(UserModel? userState) : super(BusinessModel(businessImagePath: "none")) {
    // 상태관리 인스턴스 호출 시 상태관리 대상 BusinessModel 인스턴스 초기화 (유저의 ID, Email 정보 주입)
    if(userState != null) {
      state.userModelId = userState.userModelId;
      state.email = userState.email;
    }
  }

  void uploadDocImage(String imgPath) {
    BusinessModel model = state.copyWith(businessImagePath: imgPath);

    state = model;
  }

  void cancelBusinessAuth(BuildContext context) {
    BusinessModel model = state.copyWith(
      businessNumber: "",
      businessTitle: "",
      businessCategory: "",
      businessName: "",
      businessImagePath: "none",
    );

    context.pop();

    state = model;
  }

  void applyBusinessAuth(BusinessModel state) {
    this.state = state;
  }
}