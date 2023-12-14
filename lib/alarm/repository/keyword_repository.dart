

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/keyword_model.dart';

class KeywordRepository {
  final _firestore = FirebaseFirestore.instance;

  // 키워드 목록 조회
  Future<List<KeywordModel>> readList() async {
    List<KeywordModel> result = [];

    final docRef = _firestore.collection("keyword").where("userUid");

    await docRef.get().then((value) {
      if(value == null) {
        return;
      }
      List<Map<String, dynamic>> dataList = value.docs.map((e) => e.data()).toList();
      result = KeywordModel.ofList(dataList);
    });

    return result;
  }
}