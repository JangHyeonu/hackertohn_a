
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class EventRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  QueryDocumentSnapshot<Map<String, dynamic>>? lastVisibleInReadList;

  // 행사 목록 조회
  // TODO :: 정렬 기준 변경 -> 'startDatetime'
  Future<List<Map<String, dynamic>>> readList(int limit, {String? searchText}) async {
    debugPrint("::: 메인 리스트 이벤트 조회 쿼리 실행");
    List<Map<String, dynamic>> readListResult = [];
    Query<Map<String, dynamic>> eventListQuery;

    eventListQuery = _firestore.collection("event")
        .where("endDatetime", isGreaterThan: DateTime.now());
        // .orderBy("endDatetime");

    if(searchText != null) {
      eventListQuery = eventListQuery.where(
          Filter.or(
              Filter("title", whereIn: [searchText]),
              Filter("businessName", whereIn: [searchText])
          )
      );
    }

    // 다음 페이지 내용 조회일 경우
    if(lastVisibleInReadList != null) {
      eventListQuery = eventListQuery.startAfterDocument(lastVisibleInReadList!);
    }

    // 개수 제한 추가
    eventListQuery = eventListQuery
        .limit(limit);

    // 조회 실행
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

    debugPrint("::: 메인 리스트 이벤트 조회 쿼리 종료");
    return readListResult;
  }

  // 행사 상세 조회
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

  // 행사 등록 / 수정
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

    return true;
  }

  // 행사 조회 기록 초기화
  Future<void> init() async {
    lastVisibleInReadList = null;
  }
}