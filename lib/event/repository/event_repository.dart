

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class EventRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> readList(int pageNo) async {
    QuerySnapshot<Map<String, dynamic>> _snapshot = await _firestore.collection("read_test").get();

    return _snapshot.docs.map((e) => e.data()).toList();
  }

  Future<Map<String, dynamic>> read(String eventId) async {
    return {};
  }

  Future<bool> regist(EventModel model) async {
    String? writer = UserStateNotifier.getInstance().state?.userModelId ?? "";

    if(writer == "") {
      return false;
    }

    model.regDatetime = DateTime.now();
    try {
      // 새로 추가
      if(model.eventId == null) {
        model.register = writer;
        _firestore.collection("event").add(model.toMap());
      }
      // 내용 변경
      else {
        _firestore.collection("event").doc(model.eventId).set(model.toMap());
      }
    } catch(exception) {
      debugPrint("$exception");
    }

    return true;
  }
}