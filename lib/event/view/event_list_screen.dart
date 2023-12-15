import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/component/banner_component.dart';
import 'package:seeya_hackthon_a/event/component/event_list_component.dart';
import 'package:seeya_hackthon_a/_common/component/text_form_button_component.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/event/provider/event_provider.dart';

class EventListScreen extends ConsumerStatefulWidget {
  // int? pageNo;

  EventListScreen({
    // this.pageNo,
    super.key
  });

  @override
  // ConsumerState<EventListScreen> createState() => EventListScreenState(pageNo);
  ConsumerState<EventListScreen> createState() => EventListScreenState();
}

class EventListScreenState extends ConsumerState<EventListScreen> {
  int _pageNo = 1;
  final int _limit = 5;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  // EventListScreenState(int? pageNo) {
  //    _pageNo = (pageNo == null || pageNo <= 0) ? 1 : pageNo;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLoad();
    _controller = ScrollController()..addListener(_nextLoad);
  }

  // 초기화 함수 (최초 리스트 조회, 조회 실행 여부 state 변경)
  void _initLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      // DB에서 행사 목록 조회
      await ref.read(eventListProvider.notifier).readList();
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // 다음 리스트 조회 함수
  void _nextLoad() async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _controller.position.extentAfter < 0.5) {
      // 추가 조회 중 상태 변경
      setState(() {
        _isLoadMoreRunning = true;
      });

      _pageNo += 1;

      try {
        await ref.read(eventListProvider.notifier).readList();

        if (ref.read(eventListProvider).isNotEmpty) {
          // setState(() {
          //   _albumList.addAll(fetchedPosts);
          // });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (e) {
        print(e.toString());
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.removeListener(_nextLoad);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("event list page build");

    // 행사 목록 관리 provider
    final state = ref.watch(eventListProvider);

    return DefaultLayout(
      sideBarOffYn: false,

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

      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: state.length + 1,
                itemBuilder: (context, index) {
                  // 마지막 리스트 하나 추가하기
                  if(index == state.length) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 7,
                            child: Center(
                              child: _hasNextPage || _isLoadMoreRunning ? const CircularProgressIndicator() : Text("마지막 페이지 입니다."),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        index == 0 ?
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 7,
                              child: const BannerComponent(),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ): Container(),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: InkWell(
                            onTap: () {
                              context.push("/event/detail/${state[index].eventId!}");
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: EventListComponent(
                                eventId: state[index].eventId!,
                                title: state[index].title ?? "-",
                                register: state[index].register,
                                startDatetime: state[index].startDatetime,
                                endDatetime: state[index].endDatetime,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
