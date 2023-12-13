
class AlarmModel {
  String? alarmUid;
  String? userUid;
  DateTime? regDatetime;
  String? message;

  AlarmModel({String? alarmUid, String? userUid, DateTime? regDatetime, String? message}) {
    this.alarmUid = alarmUid;
    this.userUid = userUid;
    this.regDatetime = regDatetime;
    this.message = message;
  }

  // Map -> AlarmModel 변환
  static AlarmModel of(Map<String, dynamic> dataMap) {
    return AlarmModel(
        alarmUid : dataMap["alarmUid"],
        userUid : dataMap["userUid"],
        // TODO :: timestamp -> Datetime
        regDatetime : dataMap["regDatetime"],
        message : dataMap["message"],
    );
  }

  // List<Map> -> List<AlarmModel> 변환
  static List<AlarmModel> listOf(List<Map<String, dynamic>> dataList) {
    return dataList.map((e) => (e != null) ? of(e) : AlarmModel()).toList();
  }

  // AlarmModel -> Map 변환
  Map<String, dynamic> toMap(AlarmModel model) {
    return {
      "alarmUid" : model.alarmUid,
      "userUid" : model.userUid,
      "regDatetime" : model.regDatetime,
      "message" : model.message,
    };
  }

}