
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future<void> removeAlarmById(String uId) async {
    if(state.isEmpty) {
      return;
    }

    List<AlarmModel> alarmModel = state.where((element) => element.alarmUid != uId).toList();
    bool isDelete = await _repository.delete(alarmId: uId);

    if(isDelete) {
      Fluttertoast.showToast(
          msg: "알람이 삭제 되었습니다."
      );

      state = alarmModel;
      return;
    }

    Fluttertoast.showToast(
        msg: "오류가 발생하였습니다.\n다시 시도해주세요."
    );

    return;
  }

}
