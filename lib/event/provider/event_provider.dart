
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  void regist() {
    _repository.regist(state);
  }

  // 상세 조회
  EventModel read(String eventId) {

    _repository.read(eventId)
        .then((result) => {
          state = EventModel.of(result),
        });

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

  final EventRepository _repository = EventRepository();

  EventListNotifier({
    this.eventList
  }) : super([]);

  Future<List<EventModel>?> readList() async {
    // 조회 진행
    _isLoadMoreRunning = true;

    await _repository.readList(_limit)
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
    });

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
}