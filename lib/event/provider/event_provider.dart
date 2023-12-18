
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
import 'package:seeya_hackthon_a/event/repository/event_repository.dart';

final eventProvider = StateNotifierProvider<EventNotifier, EventModel>((ref) => EventNotifier());

final eventListProvider = StateNotifierProvider<EventListNotifier, List<EventModel>>((ref) => EventListNotifier());

class EventNotifier extends StateNotifier<EventModel>{

  // 상세 조회 데이터
  // EventModel? _event;

  // EventNotifier(super._state);
  EventNotifier() : super(EventModel());

  final EventRepository _repository = EventRepository();

  // 이벤트 등록
  Future<bool?> regist() async {
    bool? isRegisted = await _repository.regist(state);

    if(isRegisted) {
      Fluttertoast.showToast(
        msg: "행사가 등록 되었습니다.",
      );
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "행사 등록에 실패했습니다.\n입력값을 확인해주세요.",
      );
      return false;
    }
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