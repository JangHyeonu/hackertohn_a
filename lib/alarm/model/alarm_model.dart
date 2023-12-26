
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeya_hackthon_a/_common/utils/my_util.dart';

class AlarmModel {
  String? alarmUid;
  String? userUid;
  DateTime? regDatetime;
  String? message;

  AlarmModel({this.alarmUid, this.userUid, this.regDatetime, this.message});

  // Map -> AlarmModel 변환
  static AlarmModel of(Map<String, dynamic> dataMap) {
    return AlarmModel(
        alarmUid : dataMap["alarmUid"],
        userUid : dataMap["userUid"],
        regDatetime : MyUtil.toDatetime(dataMap["regDatetime"]),
        message : dataMap["message"],
    );
  }

  // List<Map> -> List<AlarmModel> 변환
  static List<AlarmModel> listOf(List<Map<String, dynamic>> dataList) {
    return dataList.map((e) => (e != null) ? of(e) : AlarmModel()).toList();
  }

  // AlarmModel -> Map 변환
  Map<String, dynamic> toMap() {
    return {
      "userUid" : userUid,
      "regDatetime" : regDatetime,
      "message" : message,
    };
  }

  // AlarmModel -> Map 변환 : Uid 정보 포함
  Map<String, dynamic> toMapAll() {
    Map<String, dynamic> result = toMap();
    result["alarmUid"] = alarmUid;
    return result;
  }

}