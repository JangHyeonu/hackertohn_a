import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seeya_hackthon_a/_common/google_maps/custom_google_maps.dart';
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        state.register ?? "-",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Container(
                      width: double.infinity,
                      // alignment: Alignment.centerRight,
                      child: Text("${state.regDatetime ?? "2023-01-01"}")
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text("행사시간 : "),
                        Text("${(state.startDatetime != null) ? DateFormat("yyyy.MM.dd").format(state.startDatetime!) + " ~ " : "-"}"),
                        Text((state.endDatetime != null) ? DateFormat("yyyy.MM.dd").format(state.endDatetime!) : "-"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0,),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.title ?? "-",
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(16.0),
                      height: MediaQuery.of(context).size.height / 3,
                      child: Text(state.content ?? ""),
                    ),
                    SizedBox(height: 32.0,),
                    // 지도 및 주소, 일시 정보
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("행사장소 : ${state.location ?? "-"}"),
                          SizedBox(height: 8.0,),
                          Container(
                              height: 300,
                              child: CustomGoogleMaps()
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      )
    );
  }
}
