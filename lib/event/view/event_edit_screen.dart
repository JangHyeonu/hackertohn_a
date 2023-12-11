
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    // state 데이터의 구분값이 조회하려는 값과 같지 않으면 새로 조회
    if(eventId != state.eventId) {
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
                    InputDatePickerFormField(
                      fieldLabelText: "행사 기간",
                      firstDate: state.startDatetime ?? DateTime.now(),
                      lastDate: state.endDatetime ?? DateTime.now()),
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
                      context.go("/event/list"),
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