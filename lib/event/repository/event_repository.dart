
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeya_hackthon_a/_common/message/common_message.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

// DB 연결 :: 행사 관련
class EventRepository {
  
  // Firebase DB : Firestore
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // 마지막 조회 데이터 : 연속된 데이터를 나눠서 조회할 경우 이 데이터 기준으로 조회 해오기 위함
  QueryDocumentSnapshot<Map<String, dynamic>>? lastSnapshot;

  // readList 실행시 기본 limit 값
  final int readListDefaultLimit = 5;

  // 행사 목록 조회
  // TODO :: 정렬 기준 변경 -> 'startDatetime'  :: Firestore로는 구현이 힘들것 같음
  Future<List<EventModel>> readList({String? searchText, int? limit, bool? needInit}) async {
    // 디버깅용 출력
    debugPrint(CommonMessage.DEBUG_REPOSITORY_READ_LIST(searchText: searchText, limitCount: limit, needInit: needInit ?? false));

    // 결과
    List<Map<String, dynamic>> resultMap = [];

    // 요청 쿼리
    Query<Map<String, dynamic>> query = _firestore.collection("event");

    // 기본 조건 : 종료일이 지나지 않은 행사
    query = query
        .where("endDatetime", isGreaterThan: DateTime.now())
        .orderBy("endDatetime");

    // 검색어 조건 :: 현재 제목만 검색되는 것으로 보임
    if(searchText != null) {
      query = query.where(
          Filter.or(
              // 제목 일치
              Filter("title", whereIn: [searchText]),
              // 기업명 일치
              Filter("businessName", whereIn: [searchText]),
          )
      );
    }

    // 다음 페이지 내용 조회일 경우
    if(needInit != true && lastSnapshot != null) {
      query = query.startAfterDocument(lastSnapshot!);
    }

    // 개수 제한 추가
    query = query.limit(limit ?? readListDefaultLimit);

    // 조회 실행
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    // 조회 결과가 있는 경우 후처리
    if(querySnapshot.size > 0) {
      // 마지막 데이터 저장
      lastSnapshot = querySnapshot.docs[querySnapshot.size - 1];

      // 조회 결과 List<Map<String, dynamic>> 타입으로 변환
      resultMap = querySnapshot.docs.map((e) {
        Map<String, dynamic> data = e.data();
        // 데이터 key Map에 추가
        data["eventId"] = e.id;
        return data;
      }).toList();
    }

    return EventModel.listOf(resultMap);
  }

  // 행사 상세 조회
  Future<EventModel> read(String eventId) async {
    // 결과
    Map<String, dynamic> resultMap = {};

    // 조회할 대상이 없는 경우 빈 데이터 반환
    if(eventId == null || eventId == "") {
      return EventModel.of(resultMap);
    }

    // 조회 쿼리
    final docRef = _firestore.collection("event").doc(eventId);

    // 쿼리 실행
    await docRef.get().then((doc) => {
      resultMap = doc.data() ?? {},
      resultMap["eventId"] = doc.id,
    });

    return EventModel.of(resultMap);
  }

  // 행사 등록 / 수정
  Future<bool> register(EventModel model) async {
    UserModel userModel = UserStateNotifier.getInstance2().state!;

    if(userModel.userUid == "" || model.startDatetime == null || model.endDatetime == null) {
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
        dataMap["register"] = userModel.userUid;
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
    lastSnapshot = null;
  }
}