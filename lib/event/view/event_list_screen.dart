import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/component/banner_component.dart';
import 'package:seeya_hackthon_a/event/component/event_list_component.dart';
import 'package:seeya_hackthon_a/_common/component/text_form_button_component.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/event/provider/event_provider.dart';

import '../../_common/message/common_message.dart';

// TODO :: 필터링 조건 추가 : 내 행사 목록 조회
class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => EventListScreenState();
}

class EventListScreenState extends ConsumerState<EventListScreen> {
  late ScrollController _controller;
  final FocusNode _focusNode = FocusNode();
  late double bottomSize;

  String? _searchText;
  TextEditingController searchTextEditingController = TextEditingController();

  void searchKeyboardFn() {
    if (_focusNode.hasFocus == false) {
      setState(() {
        bottomSize = MediaQuery.of(context).viewInsets.bottom;
      });
    } else {}
  }

  void fn() async {
    if (_controller.position.extentAfter < 0.1 &&
        ref.read(eventListProvider.notifier).getHasNextPage()) {
      await Future.delayed(const Duration(milliseconds: 1000),
          () => ref.read(eventListProvider.notifier).readList());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 스크롤 관련
    _controller = ScrollController();
    _controller.addListener(fn);

    ref.read(eventListProvider.notifier).readList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(CommonMessage.DEBUG_SCREEN_BUILD(screenName: runtimeType.toString()));

    // 키보드 감지
    searchKeyboardFn();

    // 행사 목록 관리 provider
    final state = ref.watch(eventListProvider);

    return DefaultLayout(
      sideBarOffYn: false,

      // 키보드가 올라오는 영역 중 검색어 영역만 고정하기
      isResize: false,
      bottomSheetWidget: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TextFormButtonComponent(
            focusNode: _focusNode,
            textFormWidth: MediaQuery.of(context).size.width / 1.4,
            buttonText: "검색",
            buttonClickEvent: () => {
              ref
                  .read(eventListProvider.notifier)
                  .readList(searchText: _searchText, needInit: true)
                  .then((value) {
                if (value!.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                }
              }),
            },
            onChangeEvent: (p0) {
              setState(() {
                _searchText = p0;
              });
            },
            textEditingController: searchTextEditingController,
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

      child: RefreshIndicator(
        // 새로고침
        onRefresh: () async {
          // 검색어 제거
          setState(() {
            _searchText = null;
            searchTextEditingController.text = "";
          });

          // 이전 데이터 제거
          await ref.read(eventListProvider.notifier).init();
          // 새로운 데이터 조회
          await ref.read(eventListProvider.notifier).readList();
        },
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
                    if (!ref
                        .read(eventListProvider.notifier)
                        .getIsFilterSearch()) {
                      // 마지막 리스트 하나 추가하기
                      if (index == state.length) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 7,
                                child: Center(
                                  child: ref
                                          .read(eventListProvider.notifier)
                                          .getHasNextPage()
                                      ? const CircularProgressIndicator()
                                      : const Padding(
                                          padding: EdgeInsets.only(bottom: 50),
                                          child: Text("마지막 행사입니다.",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      if (index == state.length) {
                        return Container();
                      }
                    }

                    return Column(
                      children: [
                        index == 0
                            ? Column(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 7,
                                    child: const BannerComponent(),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: InkWell(
                            onTap: () {
                              context
                                  .push("/event/detail/${state[index].eventId!}");
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: EventListComponent(
                                eventId: state[index].eventId ?? "",
                                title: state[index].title ?? "-",
                                businessName: state[index].businessName,
                                startDatetime: state[index].startDatetime,
                                endDatetime: state[index].endDatetime,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
