import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/event/provider/event_provider.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailScreen({
    required this.eventId,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EventDetailScreenState(eventId: eventId);

}

class EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  final String eventId;

  EventDetailScreenState({
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    // final data = TempConst.tempListData.firstWhere((element) => element["id"] == id);
    final state = ref.watch(eventProvider);

    // state 데이터의 구분값이 조회하려는 값과 같지 않으면 새로 조회
    if(eventId != state.eventId) {
      // DB에서 데이터 조회
      ref.read(eventProvider.notifier).read(eventId ?? "");
      // TODO : 로딩
      return const DefaultLayout(sideBarOffYn: false, child: Column(),);
    }

    debugPrint("event detail build :: targetEventId : ${eventId} / stateEventId : ${state.eventId}");

    return DefaultLayout(
      sideBarOffYn: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    state.title ?? "-",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text("사업자명 : ${state.title ?? "-"}"),
                  Text("주소 : ${state.title ?? "-"}"),
                  Text("행사일시 : ${state.title ?? "-"}"),
                ],
              ),
            ),
            Container(
              color: Colors.orange,
              height: MediaQuery.of(context).size.height / 1.7,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("시작 일시 : ${(state.startDatetime != null) ? DateFormat("yyyy.MM.dd").format(state.startDatetime!) : "-"}"),
                      Text("종료 일시 : ${(state.endDatetime != null) ? DateFormat("yyyy.MM.dd").format(state.endDatetime!) : "-"}"),
                    ],
                  ),
                  Text("내용 : ${state.content ?? ""}"),
                  Expanded(
                    child: Container(
                      color: Colors.yellow,
                      height: MediaQuery.of(context).size.height / 10,
                      width: double.infinity,
                      child: Text("지도"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
