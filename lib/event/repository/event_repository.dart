

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class EventRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _limit = 50;

  Future<List<Map<String, dynamic>>> readList(int pageNo, int limit) async {

    // 첫번째 스냅샷
    // QuerySnapshot<Map<String, dynamic>> _snapshot = await _firestore.collection("event")
    //     .where("startDatetime", isGreaterThanOrEqualTo: DateTime.now())
    //     .orderBy("startDatetime")
    //     .limit(_limit)
    //     .get();

    // 첫번째 쿼리
    Query<Map<String, dynamic>> _snapshot = _firestore.collection("event")
        .where("startDatetime", isGreaterThanOrEqualTo: DateTime.now())
        .orderBy("startDatetime")
        .limit(_limit);

    // 첫번째 쿼리 스냅샷의 마지막 요소를 lastVisible 변수에 담고, 다음 쿼리의 시작 지점으로 지정 (startAfterDocument)
    _snapshot.get().then((value) {
      final lastVisible = value.docs[value.size - 1];

      final next = _firestore.collection("event")
          .where("startDatetime", isGreaterThanOrEqualTo: DateTime.now())
          .orderBy("startDatetime")
          .startAfterDocument(lastVisible)
          .limit(_limit);
    });

    List<Map<String, dynamic>> result = [];

    QuerySnapshot<Map<String, dynamic>> firstSnapShot;
    if(pageNo == 1) {
      firstSnapShot = await _snapshot.get();
      result = firstSnapShot.docs.map((e) => e.data()).toList();
      Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> docs = firstSnapShot.docs.asMap();

      for(int i = 0; i < result.length; i++) {
        result[i]["eventId"] = docs[i]?.id;

        if(result[i]["startDatetime"] != null) result[i]["startDatetime"] = (result[i]["startDatetime"] as Timestamp).toDate();
        if(result[i]["endDatetime"] != null) result[i]["endDatetime"] = (result[i]["endDatetime"] as Timestamp).toDate();
      }

      debugPrint("::: 메인 리스트 이벤트 조회 쿼리 실행");
    }

    return result;



    // List<Map<String, dynamic>> result = _snapshot.docs.map((e) => e.data()).toList();
    // Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> docs = _snapshot.docs.asMap();
    //
    // for(int i = 0; i < result.length; i++) {
    //   result[i]["eventId"] = docs[i]?.id;
    //
    //   if(result[i]["startDatetime"] != null) result[i]["startDatetime"] = (result[i]["startDatetime"] as Timestamp).toDate();
    //   if(result[i]["endDatetime"] != null) result[i]["endDatetime"] = (result[i]["endDatetime"] as Timestamp).toDate();
    // }

    // debugPrint("::: 메인 리스트 이벤트 조회 쿼리 실행");

    // return result;
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
    String? writer = UserStateNotifier.getInstance2().state?.userModelId ?? "";

    if(writer == "") {
      return false;
    }

    model.regDatetime = DateTime.now();

    Map<String, dynamic> dataMap = model.toMap();
    dataMap["startDatetime"] = Timestamp.fromDate(model.startDatetime!);
    dataMap["endDatetime"] = Timestamp.fromDate(model.endDatetime!);
    try {
      // 새로 추가
      if(model.eventId == null || model.eventId == "") {
        model.register = writer;
        await _firestore.collection("event").add(dataMap);
      }
      // 내용 변경
      else {
        await _firestore.collection("event").doc(model.eventId).set(dataMap);
      }
    } catch(exception) {
      debugPrint("$exception");
    }

    return true;
  }
}