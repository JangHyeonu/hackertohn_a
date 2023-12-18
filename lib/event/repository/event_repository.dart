
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class EventRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  QueryDocumentSnapshot<Map<String, dynamic>>? lastVisibleInReadList;

  Future<List<Map<String, dynamic>>> readList(int limit, {String? searchText}) async {
    List<Map<String, dynamic>> readListResult = [];
    Query<Map<String, dynamic>> eventListQuery;

    if(lastVisibleInReadList == null) {
      eventListQuery = _firestore.collection("event")
          .where("endDatetime", isGreaterThan: DateTime.now())
          .where("startDatetime", isNotEqualTo: null)
          .orderBy("endDatetime")
          .limit(limit);
    } else {
      eventListQuery = _firestore.collection("event")
          .where("endDatetime", isGreaterThan: DateTime.now())
          .where("startDatetime", isNotEqualTo: null)
          .orderBy("endDatetime")
          .startAfterDocument(lastVisibleInReadList!)
          .limit(limit);
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await eventListQuery.get();
    if(querySnapshot.size > 0) {
      lastVisibleInReadList = querySnapshot.docs[querySnapshot.size - 1];
    }

    readListResult = querySnapshot.docs.map((e) => e.data()).toList();
    Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs.asMap();

    for(int i = 0; i < readListResult.length; i++) {
      readListResult[i]["eventId"] = docs[i]?.id;

      if(readListResult[i]["startDatetime"] != null) readListResult[i]["startDatetime"] = (readListResult[i]["startDatetime"] as Timestamp).toDate();
      if(readListResult[i]["endDatetime"] != null) readListResult[i]["endDatetime"] = (readListResult[i]["endDatetime"] as Timestamp).toDate();
    }

    debugPrint("::: 메인 리스트 이벤트 조회 쿼리 실행");
    return readListResult;
  }






  Future<Map<String, dynamic>> read(String eventId) async {
    Map<String, dynamic> result = {};
    if(eventId == null || eventId == "") {
      return result;
    }

    final docRef = _firestore.collection("event").doc(eventId);
    await docRef.get().then((doc) => {
      if(doc.data() != null) {
        result = doc.data() as Map<String, dynamic>,
      },
      result["eventId"] = doc.id,

      if(result["startDatetime"] != null) result["startDatetime"] = (result["startDatetime"] as Timestamp).toDate(),
      if(result["endDatetime"] != null) result["endDatetime"] = (result["endDatetime"] as Timestamp).toDate(),
    });

    return result;
  }

  Future<bool> regist(EventModel model) async {
    UserModel userModel = UserStateNotifier.getInstance2().state!;

    if(userModel.userModelId == "" || model.startDatetime == null || model.endDatetime == null) {
      return false;
    }

    model.regDatetime = DateTime.now();

    Map<String, dynamic> dataMap = model.toMap();
    dataMap["startDatetime"] = Timestamp.fromDate(model.startDatetime!);
    dataMap["endDatetime"] = Timestamp.fromDate(model.endDatetime!);
    try {
      // 새로 추가
      if(model.eventId == null || model.eventId == "") {
        // 사명 유효성 검사
        if(userModel.businessModel!.businessName == null || userModel.businessModel!.businessName == "") {
          Fluttertoast.showToast(msg: "기업 정보가 유효하지 않습니다. 확인해주세요.");
          throw Exception();
        }
        dataMap["register"] = userModel.userModelId;
        dataMap["businessName"] = userModel.businessModel!.businessName!;
        await _firestore.collection("event").add(dataMap);
      }
      // 내용 변경
      else {
        await _firestore.collection("event").doc(model.eventId).set(dataMap);
      }
    } catch(exception) {
      debugPrint("$exception");
      return false;
    }

    // TODO :: 이후 스케줄러 생성시 일정 시간마다 DB 데이터 기준으로 알림 발송되도록 처리
    // 알림 발송 처리


    return true;
  }
}