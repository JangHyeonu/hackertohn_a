
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
  // List<EventModel>? _eventList;

  EventListNotifier() : super([]);

  final EventRepository _repository = EventRepository();

  List<EventModel>? readList(int pageNo) {
    _repository.readList(pageNo)
        .then((result) => {
          state = EventModel.listOf(result),
    });

    return state;
  }
}