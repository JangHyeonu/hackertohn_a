

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/keyword_model.dart';

class KeywordRepository {
  final _firestore = FirebaseFirestore.instance;

  // 키워드 목록 조회(유저 기준)
  Future<List<KeywordModel>> readList(String userUid) async {
    List<KeywordModel> result = [];

    final docRef = _firestore.collection("keyword").where("userUid", isEqualTo: userUid).where("useYn", isEqualTo: true);

    // DB 데이터 조회
    await docRef.get().then((value) {
      // 조회 데이터가 없는 경우 
      if(value == null) {
        return;
      }
      
      // Map -> Model
      List<Map<String, dynamic>> dataList = value.docs.map((e) {
        Map<String, dynamic> tempMap = e.data();
        tempMap["keywordUid"] = e.id;
        return tempMap;
      }).toList();
      
      result = KeywordModel.ofList(dataList);
    });

    return result;
  }

  // 키워드 목록 조회(키워드 기준)
  Future<List<KeywordModel>> readListByKeywordList(List<String> keywordList) async {
    List<KeywordModel> result = [];

    final docRef = _firestore.collection("keyword")
        .where("keyword", whereIn: keywordList);

    await docRef.get().then((value) {
      result = value.docs.map((e) => KeywordModel.of(e.data())).toList();
    });

    return result;
  }

  // 키워드 등록
  Future<bool> create(KeywordModel model) async {
    bool result = false;

    Map<String, dynamic> dataMap = model.toMap();

    // TODO :: 이전에 등록된 적 있는 데이터인지 확인

    // TODO :: 등록된 적 있는 데이터인 경우 useYn을 true로 변경

    // 등록된 적이 없는 데이터인 경우 새로 등록
    dataMap["regDatetime"] = Timestamp.now();
    await _firestore.collection("keyword").add(dataMap)
        .then((value) {
          if(value.id != null) {
            result = true;
          }
        })
        .catchError((error) {
          debugPrint("Error : $error");
        });

    return result;
  }

  // 키워드 데이터 갱신
  Future<bool> update(KeywordModel model) async {
    bool result = false;

    Map<String, dynamic> dataMap = model.toMap();
    dataMap["regDatetime"] = Timestamp.fromDate(model.regDatetime!);
    debugPrint("::: $dataMap");
    await _firestore.collection("keyword").doc(model.keywordUid).set(dataMap)
        .then((value) {
          result = true;
        })
        .catchError((error) {
          debugPrint("Error : $error");
        });

    return result;
  }

  // 키워드 삭제 :: useYn의 값을 false로 변경
  Future<bool> delete(KeywordModel model) async {
    
    model.useYn = false;
    
    return update(model);
  }

}