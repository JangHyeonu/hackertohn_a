
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:seeya_hackthon_a/business/provider/business_provider.dart';
import 'package:seeya_hackthon_a/business/view/business_select_popup_screen.dart';
import 'package:seeya_hackthon_a/event/provider/event_provider.dart';


class EventEditScreen extends ConsumerStatefulWidget {
  final String? eventId;
  BusinessModel? businessModel;

  EventEditScreen({this.eventId, this.businessModel, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EventEditScreenState();
}

class EventEditScreenState extends ConsumerState<EventEditScreen> {

  EventEditScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventProvider);
    final businessModel = ref.watch(businessProvider);

    if(widget.eventId != state.eventId) { // state 데이터의 구분값이 조회하려는 값과 같지 않으면 새로 조회
      // DB에서 데이터 조회
      ref.read(eventProvider.notifier).read(widget.eventId ?? "");
    }

    debugPrint("event edit build");

    return DefaultLayout (
        sideBarOffYn: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return const BusinessSelectPopupScreen();
                                    });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(Icons.fact_check_outlined),
                                    SizedBox(width: 8.0),
                                    Text("사업자 선택"),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[200],
                              ),
                              child: Center(
                                  child: Text(businessModel.businessTitle ?? "")
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          state.title = value;
                        },
                        // controller: TextEditingController(
                        //     text: state.title
                        // ),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.text_fields),
                          label: Text("행사명"),
                        ),
                      ),
                      // TODO :: 주소 입력 API
                      TextFormField(
                        onTap: () async {
                          KopoModel? model = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RemediKopo(),
                            ),
                          );

                          if (model != null) {
                            // 우편 주소
                            final postcode = model.zonecode ?? '';

                            // 주소
                            final address = model.address ?? '';
                            state.location = address;

                            // 세부 주소
                            final buildingName = model.buildingName ?? '';
                          }
                        },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
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
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
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
                                setState(() {
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
                                });
                              },
                              controller: TextEditingController(
                                text: (state.startDatetime != null) ? DateFormat("HH:mm").format(state!.startDatetime!) : "",
                              ),
                              decoration: const InputDecoration(
                                icon: Icon(Icons.access_time_filled),
                                label: Text("행사 시작 시간"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
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
                                  // 행사 시작 정보가 없거나 행사 종료일 보다 빠른 경우 행사 종료 시기와 맞춤
                                  if(state.startDatetime == null || state.endDatetime!.isBefore(state.startDatetime!)) {
                                    state.startDatetime = state.endDatetime!;
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
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
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
                                setState(() {
                                  state.endDatetime = DateTime(
                                    state.endDatetime!.year,
                                    state.endDatetime!.month,
                                    state.endDatetime!.day,
                                    selectedTime!.hour,
                                    selectedTime!.minute,
                                  );

                                  // 행사 시작 정보가 없거나 행사 종료일 보다 빠른 경우 행사 종료 시기와 맞춤
                                  if(state.startDatetime == null || state.endDatetime!.isBefore(state.startDatetime!)) {
                                    state.startDatetime = state.endDatetime!;
                                  }
                                });
                              },
                              controller: TextEditingController(
                                text: (state.endDatetime != null) ? DateFormat("HH:mm").format(state!.endDatetime!) : "",
                              ),
                              decoration: const InputDecoration(
                                icon: Icon(Icons.access_time_filled),
                                label: Text("행사 종료 시간"),
                              ),
                            ),
                          ),
                        ],
                      ),



                      Container(
                        child: TextFormField(
                          onChanged: (value) {
                            state.content = value;
                          },
                          // controller: TextEditingController(
                          //     text: state.content
                          // ),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.text_snippet),
                            label: Text("행사 내용"),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                      ),

                      TextFormField(
                        onChanged: (value) {
                          state.caution = value;
                        },
                        // controller: TextEditingController(
                        //     text: state.caution
                        // ),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.feedback_outlined),
                          label: Text("주의 사항"),
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
                          label: Text("키워드"),
                        ),
                      ),
                    ],
                  )
              ),
              ButtonBar(
                children: [
                  OutlinedButton(
                      onPressed: () => {
                        ref.read(eventProvider.notifier).regist().then((value) => {
                          if(value!) {
                            context.go("/"),
                          }
                        }),
                        ref.read(eventProvider).eventId = "registered-event",
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