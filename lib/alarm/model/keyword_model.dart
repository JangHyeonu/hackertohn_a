
import 'package:cloud_firestore/cloud_firestore.dart';

class KeywordModel {
  final String? keywordUid;
  final String? keyword;
  final String? userUid;
  final DateTime? regDatetime;
  bool? useYn;

  KeywordModel({this.keywordUid, this.keyword, this.userUid, this.regDatetime, this.useYn});

  // KeywordModel -> Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      "keyword" : keyword,
      "userUid" : userUid,
      "regDatetime" : regDatetime,
      "useYn" : useYn,
    };
  }

  // KeywordModel -> Map<String, dynamic>
  Map<String, dynamic> toMapAll() {
    return {
      "keywordUid" : keywordUid,
      "keyword" : keyword,
      "userUid" : userUid,
      "regDatetime" : regDatetime,
      "useYn" : useYn,
    };
  }

  // Map<String, dynamic> -> KeywordModel
  static KeywordModel of(Map<String, dynamic> dataMap) {
    return KeywordModel(
      keywordUid: dataMap["keywordUid"],
      keyword: dataMap["keyword"],
      userUid: dataMap["userUid"],
      regDatetime: (dataMap["regDatetime"] is DateTime) ? dataMap["regDatetime"] :
        (dataMap["regDatetime"] is Timestamp) ? dataMap["regDatetime"] :
        null,
      useYn: dataMap["useYn"],
    );
  }

  // List<Map<String, dynamic>> -> List<KeywordModel>
  static List<KeywordModel> ofList(List<Map<String, dynamic>> dataList) {
    return dataList.map((dataMap) => (dataMap != null) ? of(dataMap) : KeywordModel()).toList();
  }

}