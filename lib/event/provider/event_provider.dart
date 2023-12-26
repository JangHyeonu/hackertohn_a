
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

// 이벤트 상세 조회용 Provider
final eventProvider = StateNotifierProvider<EventNotifier, EventModel>((ref) => EventNotifier(EventModel()));

// 이벤트 목록 조회용 Provider
final eventListProvider = StateNotifierProvider<EventListNotifier, List<EventModel>>((ref) => EventListNotifier([]));

// 이벤트 상세 조회용 Notifier
class EventNotifier extends StateNotifier<EventModel>{

  EventNotifier(super._state);

  final EventRepository _repository = EventRepository();
  final AlarmRepository _alarmRepository = AlarmRepository();
  final KeywordRepository _keywordRepository = KeywordRepository();

  // 이벤트 등록
  Future<bool?> register() async {

    // DB 처리 결과 : 행사 정보 DB 등록
    bool? isRegistered = await _repository.register(state);

    // DB 처리 결과 : 실패
    if(!isRegistered) {
      return false;
    }

    // DB 처리 결과 : 성공
    //  => 알림 발송

    // 알림 발송 대상자 조회 : 키워드 맵 조회
    List<KeywordModel> keywordList = await _keywordRepository.readListByKeywordList(state.keywords!.split(","));

    // 유저 목록 정리 : 중복 제거
    Set<String> userUidSet = keywordList.map((e) => e.userUid).nonNulls.toSet();
    Set<String> messagingTokenSet = keywordList.map((e) => e.messagingToken).nonNulls.toSet();

    // 발송 메세지
    String message = "'${state.title}'(행사)가 '${state.startDatetime}'에 시작 됩니다.";

    // 해당 유저들에게 알림 발송 : DB에 메세지 내용 저장
    for(String userUid in userUidSet) {
      _alarmRepository.register(AlarmModel(alarmUid: null, userUid: userUid, message: message, regDatetime: DateTime.now()));
    }

    // PUSH 알림
    CustomFirebaseMessaging.instance.sendMessage(message: message, targetTokenList: messagingTokenSet.toList());

    return true;
  }

  // 상세 조회
  Future<EventModel> read(String eventId) async {

    _repository.read(eventId)
        .then((result) => {
          state = result,
        });

    return state;
  }

  // 데이터 초기화
  Future<EventModel> init() async {
    await () async {
      state = EventModel();
    };
    return state;
  }
}

// 이벤트 목록 조회용 Notifier
class EventListNotifier extends StateNotifier<List<EventModel>> {
  // 목록 조회 데이터
  List<EventModel>? eventList;

  final int _limit = 5;

  bool _hasNextPage = true;
  // bool _isFirstLoadRunning = true;
  // bool _isLoadMoreRunning = false;
  bool _isFilterSearch = false;

  bool _isLoadingNow = false;

  final EventRepository _repository = EventRepository();

  // EventListNotifier({
  //   this.eventList
  // }) : super([]);
  EventListNotifier(super._state);

  // 데이터 초기화
  Future<List<EventModel>?> init() async {
    debugPrint("행사 목록 데이터 초기화");
    await _repository.init();
    eventList?.clear();

    state = [];

    return state;
  }

  // 목록 조회
  Future<List<EventModel>?> readList({String? searchText, bool? needInit}) async {

    // 중복 조회 요청 방지
    if(_isLoadingNow) {
      return state;
    }
    // 초기화 유무
    if(needInit == true) {
      init();
    }

    // 조회 진행 상태값 변경 : 진행중
    // _isLoadMoreRunning = true;
    _isLoadingNow = true;

    await _repository.readList(searchText: searchText, limit: 5, needInit: needInit)
        .then((result) async => {

          if(result.isEmpty || result.length < _limit) {
            _hasNextPage = false
          } else {
            _hasNextPage = true
          },

          eventList = [...state, ...result],
          state = eventList!,

        // 조회 종료
        //_isFirstLoadRunning = false,
        //_isLoadMoreRunning = false,
        _isFilterSearch = false,
    });

    _isLoadingNow = false;

    return state;
  }

  // Future<List<EventModel>?> readListBySearch({String? searchText}) async {
  //   if(searchText == null) {
  //     return state;
  //   }
  //
  //   // 조회 진행
  //   _isLoadMoreRunning = true;
  //
  //   List<EventModel> filterList1 = eventList!.where((element) => element.title != null).toList();
  //   List<EventModel> filterList2;
  //
  //   filterList2 = filterList1.where((element) {
  //     return element.title!.contains(searchText);
  //   }).toList();
  //
  //   // 조회 종료
  //   _isLoadMoreRunning = false;
  //
  //   if(searchText == "") {
  //     _isFilterSearch = false;
  //   } else {
  //     _isFilterSearch = true;
  //   }
  //
  //   if(filterList2.isNotEmpty) {
  //     state = filterList2;
  //   } else {
  //     Fluttertoast.showToast(msg: "$searchText 조회 결과가 없습니다.");
  //     return Future.error("error");
  //   }
  //
  //   return state;
  // }

  // bool getIsMoreRunning() {
  //   return _isLoadMoreRunning;
  // }
  // bool getIsFirstLoadRunning() {
  //   return _isFirstLoadRunning;
  // }
  bool getHasNextPage() {
    return _hasNextPage;
  }
  bool getIsFilterSearch() {
    return _isFilterSearch;
  }
}