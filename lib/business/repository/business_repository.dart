import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final userState = ref.watch(userProvider);

  return BusinessRepository(userState: userState);
});

class BusinessRepository {
  final UserModel? userState;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BusinessRepository({
    this.userState
  });

  // 사업자 인증 데이터 DB에 저장
  Future<bool> applyBusinessAuth(BusinessModel businessModel) async {
    bool isInsert = false;
    UserModel? model = userState;

    if(model == null) {
      return isInsert;
    }

    // joinType 오류로 데이터 직접 기입
    String uId = "${"GOOGLE_OAUTH".toLowerCase()}_${model.userModelId!}";

    // DB에서 계정정보 조회
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore.collection("user").doc(uId).get();

    // 계정정보 존재 & businessAuth 인증 칼럼 없을 때 DB 삽입
    if(documentSnapshot != null && !(documentSnapshot.data()!.containsKey("businessAuth"))) {

      Map<String, dynamic> businessAuthMap = businessModel.update("apply").toJson();

      _firestore.collection("user").doc(uId).update({"businessAuth": businessAuthMap});
      isInsert = true;
    }

    return isInsert;
  }

  // 유저의 BusinessAuth 정보 가져오기
  Future<Map<String, dynamic>?> selectBusinessAuth(String? uid) async {
    String uId = "${"GOOGLE_OAUTH".toLowerCase()}_${uid}";

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore.collection("user").doc(uId).get();

    if(documentSnapshot.data() == null) {
      return null;
    }

    Map<String, dynamic>? dataMap = documentSnapshot.data();
    Map<String, dynamic>? businessAuthMap = dataMap!["businessAuth"];

    return businessAuthMap;

  }






}