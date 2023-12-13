import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/component/banner_component.dart';
import 'package:seeya_hackthon_a/event/component/event_list_component.dart';
import 'package:seeya_hackthon_a/_common/component/text_form_button_component.dart';
import 'package:seeya_hackthon_a/_common/const/temp_const.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/event/provider/event_provider.dart';

class EventListScreen extends ConsumerStatefulWidget {
  int? pageNo;

  EventListScreen({
    this.pageNo,
    super.key
  });

  @override
  ConsumerState<EventListScreen> createState() => EventListScreenState(pageNo);
}

class EventListScreenState extends ConsumerState<EventListScreen> {
  int _pageNo = 1;
  EventListScreenState(int? pageNo) {
     this._pageNo = pageNo ?? 1;
  }

  @override
  Widget build(BuildContext context) {

    // 행사 목록 관리 provider
    final state = ref.watch(eventListProvider);

    // DB에서 행사 목록 조회
    // ref.read(eventListProvider.notifier).readList(_pageNo);

    return DefaultLayout(

      // 키보드가 올라오는 영역 중 검색어 영역만 고정하기
      isResize: false,
      bottomSheetWidget: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TextFormButtonComponent(
            textFormWidth: MediaQuery.of(context).size.width / 1.4,
            buttonText: "검색",
            buttonClickEvent: () => {},
            inputDecoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              icon: Icon(Icons.search),
              hintText: "검색어를 입력하세요",
            ),
          ),
        ),
      ),

      sideBarOffYn: false,

      child: Column(
        children: [
          // 메인
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 배너
                Container(
                  height: MediaQuery.of(context).size.height / 7,
                  child: BannerComponent(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                // 행사 리스트
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView.separated(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          context.push("/event/detail/${state[index].eventId!}");
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Colors.grey[200]
                          ),
                          child: EventListComponent(
                            eventId: state[index].eventId!,
                            title: state[index].title ?? "-",
                            startDatetime: state[index].startDatetime,
                            endDatetime: state[index].endDatetime,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
