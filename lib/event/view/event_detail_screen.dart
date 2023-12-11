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

    // DB에서 행사 데이터 조회
    ref.read(eventProvider.notifier).read(eventId);
    debugPrint("event detail build");

    return DefaultLayout(
      sideBarOffYn: false,
      child: Column(
        children: [
          Container(
            color: Colors.yellow,
            height: MediaQuery.of(context).size.height / 5,
            width: double.infinity,
            child: Column(
              children: [
                Text("제목 : ${state.title ?? "-"}"),
              ],
            ),
          ),
          Container(
            color: Colors.orange,
            height: MediaQuery.of(context).size.height / 1.5,
            width: double.infinity,
            child: Column(
              children: [
                Text("내용 : ${state.content ?? ""}"),
                Text("시작 시간 : ${(state.startDatetime != null) ? DateFormat("YYYY.MM.DD").format(state.startDatetime!) : "-"}"),
                Text("종료 시간 : ${(state.endDatetime != null) ? DateFormat("YYYY.MM.DD").format(state.endDatetime!) : "-"}"),
              ],
            ),
          ),
        ],
      )
    );
  }
}
