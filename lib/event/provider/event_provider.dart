
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeya_hackthon_a/_common/firebse_messaging/custom_firebase_messaging.dart';
import 'package:seeya_hackthon_a/alarm/model/keyword_model.dart';
import 'package:seeya_hackthon_a/alarm/repository/alarm_repository.dart';
import 'package:seeya_hackthon_a/alarm/repository/keyword_repository.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
import 'package:seeya_hackthon_a/event/repository/event_repository.dart';

import '../../alarm/model/alarm_model.dart';

final eventProvider = StateNotifierProvider<EventNotifier, EventModel>((ref) => EventNotifier());

final eventListProvider = StateNotifierProvider<EventListNotifier, List<EventModel>>((ref) => EventListNotifier());

class EventNotifier extends StateNotifier<EventModel>{

  // 상세 조회 데이터
  // EventModel? _event;

  // EventNotifier(super._state);
  EventNotifier() : super(EventModel());

  final EventRepository _repository = EventRepository();
  final AlarmRepository _alarmRepository = AlarmRepository();
  final KeywordRepository _keywordRepository = KeywordRepository();

  // 이벤트 등록
  Future<bool?> regist() async {
    bool? isRegisted = await _repository.regist(state);

    // DB 등록 실패
    if(!isRegisted) {
      Fluttertoast.showToast(
        msg: "행사 등록에 실패했습니다.\n입력값을 확인해주세요.",
      );
      return false;
    }

    // 알림 발송
    // 키워드 맵 조회
    List<KeywordModel> keywordList = await _keywordRepository.readListByKeywordList(state.keywords!.split(","));

    // 유저 목록 정리
    Set<String> userUidSet = keywordList.map((e) => e.userUid).nonNulls.toSet();
    Set<String> messagingTokenSet = keywordList.map((e) => e.messagingToken).nonNulls.toSet();

    String message = "'${state.title}'(행사)가 '${state.startDatetime}'에 시작 됩니다.";

    if(userUidSet.isNotEmpty) {
      for(String userUid in userUidSet) {
        // 해당 유저들에게 알림 발송
        _alarmRepository.register(AlarmModel(alarmUid: null, userUid: userUid, message: message, regDatetime: DateTime.now()));
        // PUSH 알림
      }
    }

    CustomFirebaseMessaging.instance.sendMessage(message: message, toTokens: messagingTokenSet.toList());

    return true;
  }

  // 상세 조회
  Future<EventModel> read(String eventId) async {

    _repository.read(eventId)
        .then((result) => {
          state = EventModel.of(result),
        });

    return state;
  }

  // 데이터 초기화
  Future<EventModel> init() async {
    state = EventModel();
    return state;
  }
}

class EventListNotifier extends StateNotifier<List<EventModel>> {
  // 목록 조회 데이터
  List<EventModel>? eventList;

  final int _limit = 5;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = true;
  bool _isLoadMoreRunning = false;
  bool _isFilterSearch = false;

  final EventRepository _repository = EventRepository();

  EventListNotifier({
    this.eventList
  }) : super([]);

  Future<List<EventModel>?> init() async {
    await _repository.init();
    eventList?.clear();

    state = [];

    return state;
  }

  Future<List<EventModel>?> readList({String? searchText}) async {
    // 조회 진행
    _isLoadMoreRunning = true;

    await _repository.readList(_limit, searchText: searchText)
        .then((result) async => {

          if(result.isEmpty || result.length < _limit) {
            _hasNextPage = false
          } else {
            _hasNextPage = true
          },

          eventList = [...state, ...EventModel.listOf(result)],
          state = eventList!,

        // 조회 종료
        _isFirstLoadRunning = false,
        _isLoadMoreRunning = false,
        _isFilterSearch = false,
    });

    return state;
  }

  Future<List<EventModel>?> readListBySearch({String? searchText}) async {
    if(searchText == null) {
      return state;
    }

    // 조회 진행
    _isLoadMoreRunning = true;

    List<EventModel> filterList1 = eventList!.where((element) => element.title != null).toList();
    List<EventModel> filterList2;

    filterList2 = filterList1.where((element) {
      return element.title!.contains(searchText);
    }).toList();

    // 조회 종료
    _isLoadMoreRunning = false;

    if(searchText == "") {
      _isFilterSearch = false;
    } else {
      _isFilterSearch = true;
    }

    if(filterList2.isNotEmpty) {
      state = filterList2;
    } else {
      Fluttertoast.showToast(msg: "$searchText 조회 결과가 없습니다.");
      return Future.error("error");
    }

    return state;
  }

  bool getIsMoreRunning() {
    return _isLoadMoreRunning;
  }
  bool getIsFirstLoadRunning() {
    return _isFirstLoadRunning;
  }
  bool getHasNextPage() {
    return _hasNextPage;
  }
  bool getIsFilterSearch() {
    return _isFilterSearch;
  }
}