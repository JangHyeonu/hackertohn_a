import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seeya_hackthon_a/_common/google_maps/custom_google_maps.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/event/component/detail_icon_text_component.dart';
import 'package:seeya_hackthon_a/event/component/event_list_component.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';
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
    bool isLoading = true;
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                child: EventListComponent(
                  eventId: eventId,
                  title: state.title!,
                  businessTitle: state.businessTitle,
                  startDatetime: state.startDatetime,
                  endDatetime: state.endDatetime,
                  keyword: state.keywords,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,4),
                    child: DetailIconTextComponent(
                      icon: Icons.event,
                      title: "행사 시작 : ",
                      content: DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(state.startDatetime!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,4),
                    child: DetailIconTextComponent(
                      icon: Icons.event_available,
                      title: "행사 종료 : ",
                      content: DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(state.endDatetime!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              DetailIconTextComponent(
                                icon: Icons.location_on_sharp,
                                title: "행사 장소",
                              ),
                              Expanded(child: Container()),
                              Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await openMapDialog(state);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(10, 30),
                                        // surfaceTintColor: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        backgroundColor: Colors.white70,
                                        foregroundColor: Colors.black
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.map),
                                          Text(" Map"),
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Text(
                                "${state.location}\n${state.locationDetail}" ?? "",
                                style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.visible,
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,16),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailIconTextComponent(
                            icon: Icons.my_library_books,
                            content: "행사 내용",
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            height: MediaQuery.of(context).size.height / 3,
                            child: Text(
                              state.content ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.visible,
                              )),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 8.8,
                          child: Image.asset("assets/image/noimage.gif", fit: BoxFit.fitHeight),
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 8.8,
                          child: Image.asset("assets/image/noimage.gif", fit: BoxFit.fitHeight),
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 8.8,
                          child: Image.asset("assets/image/noimage.gif", fit: BoxFit.fitHeight),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Future openMapDialog(EventModel state) {

    return showDialog(
      context: context,
      barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
      builder: ((context) {
        return FittedBox(
          child: AlertDialog(
            content: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    children: [
                      DetailIconTextComponent(
                        icon: Icons.location_on_sharp,
                        title: "행사 장소",
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          "${state.location}\n${state.locationDetail}" ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.visible,
                          )
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white38
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("지도 표출 영역", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(8,0,8,8),
                        child: CustomGoogleMaps(eventState: state),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            actions: <Widget>[
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); //창 닫기
                  },
                  child: Text("닫기"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

}


