

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeya_hackthon_a/alarm/model/keyword_model.dart';
import 'package:seeya_hackthon_a/alarm/repository/keyword_repository.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

final keywordListProvider = StateNotifierProvider<KeywordListStateNotifier, List<KeywordModel>>((ref) {

  return KeywordListStateNotifier();
});

class KeywordListStateNotifier extends StateNotifier<List<KeywordModel>> {

  final KeywordRepository _repository = KeywordRepository();

  // KeywordListStateNotifier(super._state);
  KeywordListStateNotifier() : super([]);

  // 목록 조회
  List<KeywordModel> readList() {
    debugPrint("KeywordListStateNotifier :: readList :: start");

    String? userUid = UserStateNotifier.getInstance2().state!.userModelId;

    // 유저 구분값이 유효하지 않은 경우
    if(userUid == null || userUid == "") {
      debugPrint("Error :: invalid value : userUid");
      return [];
    }

    _repository.readList(userUid).then((value) {
      state = value;
    });

    debugPrint("KeywordListStateNotifier :: readList :: end");
    return state;
  }
}