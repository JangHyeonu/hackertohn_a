import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeya_hackthon_a/_common/utils/my_util.dart';

class EventModel {

  // 데이터 구분값
  String? eventId;
  // 제목
  String? title;
  // 내용
  String? content;
  // 우편주소
  String? postcode;
  // 주소
  String? location;
  // 상세 주소
  String? locationDetail;
  // 위도
  double? latitude;
  // 경도
  double? longitude;
  // 시작 시기
  DateTime? startDatetime;
  // 종료 시기
  DateTime? endDatetime;
  // 주의 사항
  String? caution;
  // 키워드 목록
  String? keywords;
  // 등록자 구분 uid
  String? register;
  // 등록 시기
  DateTime? regDatetime;
  // 등록 기업명
  String? businessName;

  EventModel({
    this.eventId,
    this.title,
    this.content,
    this.postcode,
    this.location,
    this.locationDetail,
    this.latitude,
    this.longitude,
    this.startDatetime,
    this.endDatetime,
    this.caution,
    this.keywords,
    this.register,
    this.regDatetime,
    this.businessName,
  });

  // ignore: non_constant_identifier_names
  EventModel.Empty();

  //  Model -> Map
  Map<String, dynamic> toMap() {
    return {
      "title" : title,
      "content" : content,
      "postcode" : postcode,
      "location" : location,
      "locationDetail" : locationDetail,
      "latitude" : latitude,
      "longitude" : longitude,
      "startDatetime" : startDatetime,
      "endDatetime" : endDatetime,
      "caution" : caution,
      "keywords" : keywords,
      "register" : register,
      "regDatetime" : regDatetime,
      "businessName" : businessName,
    };
  }

  //  Model -> Map :: All Data
  Map<String, dynamic> toMapAllData() {
    Map<String, dynamic> result = toMap();
    result["eventId"] = eventId;
    return result;
  }

  // Map -> Model
  static EventModel of(Map<String, dynamic> map) {
    return EventModel(
      eventId: map["eventId"],
      title: map["title"],
      content: map["content"],
      postcode: map["postcode"],
      location: map["location"],
      locationDetail: map["locationDetail"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      startDatetime: MyUtil.toDatetime(map["startDatetime"]),
      endDatetime: MyUtil.toDatetime(map["endDatetime"]),
      caution: map["caution"],
      keywords : map["keywords"],
      register: map["register"],
      regDatetime: MyUtil.toDatetime(map["regDatetime"]),
      businessName: map["businessName"],
    );
  }

  // List<Map> -> List<Model>
  static List<EventModel> listOf(List<Map<String, dynamic>> list) {
    return list.map((e) => (e != null) ? of(e) : EventModel()).toList();
  }

}