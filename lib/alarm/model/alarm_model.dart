
import 'package:cloud_firestore/cloud_firestore.dart';

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
        regDatetime : (dataMap["regDatetime"] is DateTime) ? dataMap["regDatetime"]
            : (dataMap["regDatetime"] is Timestamp) ? (dataMap["regDatetime"] as Timestamp).toDate()
            : null,
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

  Map<String, dynamic> toMapAll() {
    Map<String, dynamic> result = toMap();
    result["alarmUid"] = alarmUid;
    return result;
  }

}