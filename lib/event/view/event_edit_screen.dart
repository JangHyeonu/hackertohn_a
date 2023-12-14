
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/event/provider/event_provider.dart';


class EventEditScreen extends ConsumerStatefulWidget {
  final String? eventId;
  const EventEditScreen({this.eventId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EventEditScreenState(eventId);
}

class EventEditScreenState extends ConsumerState<EventEditScreen> {
  final String? eventId;

  EventEditScreenState(this.eventId);

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(eventProvider);
    
    if(eventId != state.eventId) { // state 데이터의 구분값이 조회하려는 값과 같지 않으면 새로 조회
      // DB에서 데이터 조회
      ref.read(eventProvider.notifier).read(eventId ?? "");
    }

    debugPrint("event edit build");

    return DefaultLayout (
      sideBarOffYn: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        state.title = value;
                      },
                      controller: TextEditingController(
                          text: state.title
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.text_fields),
                        label: Text("행사명"),
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        state.content = value;
                      },
                      controller: TextEditingController(
                          text: state.content
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.text_snippet),
                        label: Text("행사 내용"),
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        state.location = value;
                      },
                      controller: TextEditingController(
                          text: state.location
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.text_fields),
                        label: Text("행사 장소"),
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2024, DateTime.now().month, DateTime.now().day),
                          currentDate: state.startDatetime ?? DateTime.now(),
                        );
                        setState(() {
                          // 이전 데이터가 없으면 치환
                          if(state.startDatetime == null) {
                            state.startDatetime = selectedDate;
                          // 이전 데이터가 있으면 시, 분 데이터 유지
                          } else {
                            state.startDatetime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, state.startDatetime!.hour, state.startDatetime!.minute);
                          }
                        });

                        // 행사 종료일이 없거나 행사 시작일 보다 빠른 경우 행사 시작일과 시기를 맞춤
                        if(state.endDatetime == null || state.endDatetime!.isBefore(state.startDatetime!)) {
                          state.endDatetime = state.startDatetime!;
                        }
                      },
                      controller: TextEditingController(
                        text: (state.startDatetime != null) ? DateFormat("yyyy.MM.dd").format(state!.startDatetime!) : "",
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.date_range),
                        label: Text("행사 시작일"),
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        // 년, 월, 일 데이터가 없는 경우
                        if(state.startDatetime == null) {
                          Fluttertoast.showToast(msg: "년,월,일을 먼저 선택해주세요");
                          FocusScope.of(context).previousFocus();
                          return;
                        }
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        state.startDatetime = DateTime(
                          state.startDatetime!.year,
                          state.startDatetime!.month,
                          state.startDatetime!.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );

                        // 행사 종료일이 없거나 행사 시작일 보다 빠른 경우 행사 시작일과 시기를 맞춤
                        if(state.endDatetime == null || state.endDatetime!.isBefore(state.startDatetime!)) {
                          state.endDatetime = state.startDatetime!;
                        }
                      },
                      controller: TextEditingController(
                          text: (state.startDatetime != null) ? DateFormat("HH:mm").format(state!.startDatetime!) : "",
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.access_time_filled),
                        label: Text("행사 시작 시간"),
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2024, DateTime.now().month, DateTime.now().day),
                          currentDate: state.endDatetime ?? DateTime.now(),
                        );
                        setState(() {
                          // 이전 데이터가 없으면 치환
                          if(state.endDatetime == null) {
                            state.endDatetime = selectedDate;
                            // 이전 데이터가 있으면 시, 분 데이터 유지
                          } else {
                            state.endDatetime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, state.endDatetime!.hour, state.endDatetime!.minute);
                          }
                        });
                      },
                      controller: TextEditingController(
                        text: (state.endDatetime != null) ? DateFormat("yyyy.MM.dd").format(state!.endDatetime!) : "",
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.date_range),
                        label: Text("행사 종료일"),
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        // 년, 월, 일 데이터가 없는 경우
                        if(state.endDatetime == null) {
                          Fluttertoast.showToast(msg: "년,월,일을 먼저 선택해주세요");
                          FocusScope.of(context).previousFocus();
                          return;
                        }
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        state.endDatetime = DateTime(
                          state.endDatetime!.year,
                          state.endDatetime!.month,
                          state.endDatetime!.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );
                      },
                      controller: TextEditingController(
                        text: (state.endDatetime != null) ? DateFormat("HH:mm").format(state!.endDatetime!) : "",
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.access_time_filled),
                        label: Text("행사 종료 시간"),
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        state.caution = value;
                      },
                      controller: TextEditingController(
                          text: state.caution
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.text_snippet),
                        label: Text("주의 사항"),
                      ),
                    ),
                  ],
                )
            ),
            ButtonBar(
              children: [
                OutlinedButton(
                    onPressed: () => {
                      ref.read(eventProvider.notifier).regist(),
                      ref.read(eventProvider).eventId = "registered-event",
                      context.go("/"),
                    },
                    child: const Text("등록하기")
                )
              ],
            )
          ],
        ),
      )
    );
  }

}