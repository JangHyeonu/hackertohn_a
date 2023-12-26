import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';
import 'package:seeya_hackthon_a/business/repository/business_repository.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

final businessProvider = StateNotifierProvider<BusinessStateNotifier, BusinessModel>((ref) {
  // 사용자의 정보를 담은 userProvider를 이용하여 UserModel 인스턴스의 상태를 관리
  final userState = ref.watch(userProvider);
  // 사업자 로직이 담긴 레파지토리
  final businessRepository = ref.watch(businessRepositoryProvider);

  return BusinessStateNotifier(
    userState: userState,
    businessRepository: businessRepository,
    ref: ref,
  );

});

class BusinessStateNotifier extends StateNotifier<BusinessModel> {
  final UserModel? userState;
  final BusinessRepository businessRepository;
  final Ref ref;

  BusinessStateNotifier({
    this.userState,
    required this.businessRepository,
    required this.ref,
  }) : super(
      BusinessModel(
        businessImagePath: "none"
      ),
  ) {
    // 상태관리 인스턴스 호출 시 상태관리 대상 BusinessModel 인스턴스 초기화 (유저의 ID, Email 정보 주입)
    if(userState != null) {
      state.userUid = userState?.userUid;
      state.email = userState?.email;
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
      businessAddress: "",
      businessCategory: "",
      businessName: "",
      businessImagePath: "none",
      applyState: null,
    );

    context.pop();

    state = model;
  }

  Future<String> applyBusinessAuth(BusinessModel state, BuildContext context) async {

    if(state == null) {
      return state.applyState!;
    }

    // 사용자의 인증 입력 데이터 DB 저장 로직
    bool isInsert = await businessRepository.applyBusinessAuth(state);

    // DB 저장 시 user의 상태 변경 -> state값은 user에 있는지? user 안의 business에 있는지?
    if(isInsert) {
      ref.read(userProvider.notifier).setState("apply");
    }

    // 위젯 트리에 state(인스턴스)가 있을 경우에만 상태값 변경
    if(mounted) {
      this.state = state;
    }


    return state.applyState!;
  }

  // businessAuth 조회하기
  Future<BusinessModel?> getBusinessAuth(String? uid) async {
    Map<String, dynamic>? businessAuthMap = await businessRepository.selectBusinessAuth(uid);

    // 승인 상태이면 사업자 권한 제공
    // if(businessAuthMap?["applyState"] == "approve") {
    //   setUpdateAuth(uid, "business");
    // }

    BusinessModel businessModel = BusinessModel.fromJson(businessAuthMap);

    if(mounted) {
      state = businessModel;
    }

    return state;
  }

  Future<BusinessModel?> getBusinessByBusinessNumber(String? businessNumber) async {
    BusinessModel? businessModel = await getBusinessAuth(userState?.userUid);

    if(businessModel?.businessNumber == businessNumber) {
      state = businessModel!;
    }
    return state;
  }

  // void updateBusinessAuth() async {
  //   ref.read(userProvider.notifier).setState("approve");
  // }

  void setUpdateAuth(String uid) {
    businessRepository.updateBusinessAuth(uid, state);
  }



}