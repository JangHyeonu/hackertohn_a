

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/alarm/component/alarm_list_component.dart';
import 'package:seeya_hackthon_a/alarm/provider/alarm_provider.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class AlarmListScreen extends ConsumerStatefulWidget {
  int? pageNo;

  AlarmListScreen({
    int? pageNo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AlarmListScreenState(pageNo);
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

    ref.read(alarmListProvider.notifier).readList(1);

    debugPrint("::: ${UserStateNotifier.getInstance2().state?.userModelId}");
    debugPrint("::: ${ref.read(alarmListProvider).length}");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("alarmListScreen build!!");

    final state = ref.watch(alarmListProvider);

    return DefaultLayout(
        sideBarOffYn: false,
        child: Column(
          children: [
            // 키워드 선택 부분
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.blueGrey,
              child: Text("키워드 파트"),
            ),
            // 알림 목록 부분
            Container(
              // child: ListView.separated(
              //   itemCount: state.length,
              //   itemBuilder: (context, index) {
              //     return InkWell(
              //       onTap: () {
              //         // context.push("/alarm/detail/${state[index].alarmUid!}");
              //       },
              //       child: Ink(
              //         decoration: BoxDecoration(
              //             color: Colors.grey[200]
              //         ),
              //         child: AlarmListComponent(
              //           alarmUid: state[index].alarmUid,
              //           regDateTime: state[index].regDatetime,
              //           message: state[index].message,
              //         ),
              //       ),
              //     );
              //   },
              //   separatorBuilder: (context, index) {
              //     return const Divider();
              //   },
              // ),
            ),
          ],
        ),
    );
  }

}