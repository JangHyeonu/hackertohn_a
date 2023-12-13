
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeya_hackthon_a/alarm/model/alarm_model.dart';

import '../repository/alarm_repository.dart';

final alarmProvider = StateNotifierProvider<AlarmNotifier, AlarmModel> ((ref) => AlarmNotifier());

final alarmListProvider = StateNotifierProvider<AlarmListNotifier, List<AlarmModel>> ((ref) => AlarmListNotifier());

// 알람 provider
class AlarmNotifier extends StateNotifier<AlarmModel> {
  AlarmNotifier() : super(AlarmModel());
}

// 알람 목록 provider
class AlarmListNotifier extends StateNotifier<List<AlarmModel>> {
  final _repository = AlarmRepository();
  AlarmListNotifier() : super([]);

  void readList(int pageNo) {
    _repository.readList(pageNo)
      .then((value) => {state = value});
  }
}
