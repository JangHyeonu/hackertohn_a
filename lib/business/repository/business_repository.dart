import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeya_hackthon_a/_common/user/user_function.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final userState = ref.watch(userProvider);

  final userFunction = UserFunction();

  return BusinessRepository(userState: userState);
});

class BusinessRepository {
  final UserModel? userState;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BusinessRepository({
    this.userState
  });

  // 사업자 인증 데이터 DB에 저장
  Future<void> applyBusinessAuth() async {
    UserModel? model = userState;

    if(model == null) {
      return;
    }

    String uId = "${model.joinType!.name.toLowerCase()}_${model.userModelId!}";

    // DB에서 계정정보 조회
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore.collection("user").doc(uId).get();

    if(documentSnapshot.id != null) {

      // todo : 나중에 UserModel 객체를 쓰는 쪽으로 수정하기
      DocumentReference<Map<String, dynamic>> updateUserModel = documentSnapshot.reference;
      // updateUserModel.update();

      _firestore.collection("user").doc(uId).update({"id":"id"});


    }





  }




}