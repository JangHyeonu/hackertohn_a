

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/keyword_model.dart';

class KeywordRepository {
  final _firestore = FirebaseFirestore.instance;

  // 키워드 목록 조회
  Future<List<KeywordModel>> readList(String userUid) async {
    List<KeywordModel> result = [];

    final docRef = _firestore.collection("keyword").where("userUid", isEqualTo: userUid);

    // DB 데이터 조회
    await docRef.get().then((value) {
      // 조회 데이터가 없는 경우 
      if(value == null) {
        return;
      }
      
      // Map -> Model
      List<Map<String, dynamic>> dataList = value.docs.map((e) {
        e.data()["keywordUid"] = e.id;
        return e.data();
      }).toList();
      
      result = KeywordModel.ofList(dataList);
    });

    return result;
  }

  // 키워드 등록
  Future<bool> create(KeywordModel model) async {
    bool result = false;

    Map<String, dynamic> dataMap = model.toMap();

    await _firestore.collection("keyword").add(dataMap)
        .then((value) {
          if(value.id != null) {
            result = true;
          }
    });

    return result;
  }

  // 키워드 데이터 갱신
  Future<bool> update(KeywordModel model) async {
    bool result = false;

    Map<String, dynamic> dataMap = model.toMap();

    await _firestore.collection("keyword").doc(model.keywordUid).set(dataMap);

    return result;
  }
}