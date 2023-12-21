
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KeywordModel {
  final String? keywordUid;
  final String? keyword;
  final String? userUid;
  final String? messagingToken;
  final DateTime? regDatetime;
  bool? useYn =  true;

  KeywordModel({this.keywordUid, this.keyword, this.userUid, this.messagingToken, this.regDatetime, this.useYn});

  // KeywordModel -> Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      "keyword" : keyword,
      "userUid" : userUid,
      "messagingToken" : messagingToken,
      "regDatetime" : regDatetime,
      "useYn" : useYn,
    };
  }

  // KeywordModel -> Map<String, dynamic>
  Map<String, dynamic> toMapAll() {
    Map<String, dynamic> result = toMap();
    result["keywordUid"] = keywordUid;
    return result;
  }

  // Map<String, dynamic> -> KeywordModel
  static KeywordModel of(Map<String, dynamic> dataMap) {
    return KeywordModel(
      keywordUid: dataMap["keywordUid"],
      keyword: dataMap["keyword"],
      userUid: dataMap["userUid"],
      messagingToken : dataMap["messagingToken"],
      regDatetime: (dataMap["regDatetime"].runtimeType == DateTime) ? dataMap["regDatetime"] :
        (dataMap["regDatetime"].runtimeType == Timestamp) ? (dataMap["regDatetime"] as Timestamp).toDate() :
        null,
      useYn: dataMap["useYn"],
    );
  }

  // List<Map<String, dynamic>> -> List<KeywordModel>
  static List<KeywordModel> ofList(List<Map<String, dynamic>> dataList) {
    return dataList.map((dataMap) => (dataMap != null) ? of(dataMap) : KeywordModel()).toList();
  }

}