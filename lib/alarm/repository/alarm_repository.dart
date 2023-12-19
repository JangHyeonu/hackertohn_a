

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

import '../model/alarm_model.dart';

class AlarmRepository {
  final _firestore = FirebaseFirestore.instance;

  // 알람 조회
  Future<AlarmModel> read(String alarmId) async {
    Map<String, dynamic> resultMap = {};

    final docRef = _firestore.collection("alarm").doc(alarmId);

    await docRef.get().then((doc) => {
      if(doc.data() != null) {
        resultMap = doc.data() as Map<String, dynamic>,
      },
      resultMap["alarmUid"] = doc.id,
    });

    return AlarmModel.of(resultMap);
  }

  // 알람 목록 조회
  Future<List<AlarmModel>> readList(int pageNo) async {
    List<Map<String, dynamic>> resultList = [];

    // 파라메터 유효 검사
    if(pageNo < 1) {
      return [];
    }

    final docRef = _firestore.collection("alarm")
        .where("userUid", isEqualTo:UserStateNotifier.getInstance2().state!.userModelId!)
        .orderBy("regDatetime", descending: true)
        .limit(10);

    await docRef.get().then((queryResult) => {
      if(queryResult != null) {
        resultList = queryResult.docs.map((e) => e.data()).toList(),
      },
    });

    return (resultList != null) ? AlarmModel.listOf(resultList) : [];
  }

  // 알림 발송
  Future<bool> register(AlarmModel alarmModel) async {
    bool result = false;

    _firestore.collection("alarm").add(alarmModel.toMap());

    result = true;
    return result;
  }

  // 알림 제거
  Future<bool> delete({String? alarmId}) async {
    bool result = false;

    final docRef = _firestore.collection("alarm").doc(alarmId).get();


    return true;
  }

}