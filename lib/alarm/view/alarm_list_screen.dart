

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/alarm/component/alarm_list_component.dart';
import 'package:seeya_hackthon_a/alarm/component/keyword_component.dart';
import 'package:seeya_hackthon_a/alarm/provider/alarm_provider.dart';

class AlarmListScreen extends ConsumerStatefulWidget {
  int? pageNo;

  AlarmListScreen({
    int? pageNo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() { return AlarmListScreenState(pageNo); }
}

class AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  int _pageNo = 1;

  AlarmListScreenState(int? pageNo) {
    _pageNo = (pageNo == null || pageNo <= 0) ? 1 : pageNo;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // DB 데이터 조회 : 알람 목록
    ref.read(alarmListProvider.notifier).readList(1);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("alarmListScreen build!!");

    final state = ref.watch(alarmListProvider);

    return DefaultLayout(
        sideBarOffYn: false,
        isResize: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              // TODO
              // 키워드 선택 부분
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: const KeywordComponent(),
              ),
              // 알림 목록 부분
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: Key(state[index].alarmUid!),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (context) {
                                ref.read(alarmListProvider.notifier).removeAlarmById(state[index].alarmUid!);
                              },
                              backgroundColor: Theme.of(context).colorScheme.error,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever_rounded,
                              label: '알람 삭제',
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: AlarmListComponent(
                            alarmUid: state[index].alarmUid,
                            regDateTime: state[index].regDatetime,
                            message: state[index].message,
                          ),
                        ),
                      );
                    },
                  )
              ),
            ],
          ),
        ),
    );
  }

}