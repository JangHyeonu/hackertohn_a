
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/alarm/model/keyword_model.dart';
import 'package:seeya_hackthon_a/alarm/provider/keyword_provider.dart';
import 'package:seeya_hackthon_a/alarm/repository/keyword_repository.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class KeywordComponent extends ConsumerStatefulWidget {
  const KeywordComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() { return KeywordComponentState(); }
}

class KeywordComponentState extends ConsumerState<KeywordComponent> {

  KeywordComponentState();

  String _inputKeywordText = "";
  final _keywordRepository = KeywordRepository();

  bool _reflash = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    ref.read(keywordListProvider.notifier).readList();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("KeywordComponent build :: ");

    final keywordListState = ref.watch(keywordListProvider);
    final keywordListWidgets = keywordListState.map((e) => KeywordItem(keywordModel: e, onDeletedCallback: () { ref.read(keywordListProvider.notifier).readList(); },)).toList();

    return Container(
      color: Colors.teal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                margin: const EdgeInsets.only(left: 20, right: 10),
                child: TextFormField(
                  controller: TextEditingController(
                    text: _inputKeywordText
                  ),
                  onChanged: (value) {
                    // TODO :: 입력 받은 값으로 기존 키워드 검색 후 키워드 목록 선택지 출력 => 선택한 키워드로 값 대체
                    _inputKeywordText = value;
                  },
                  decoration: const InputDecoration(
                      icon: Icon(Icons.text_fields),
                      label: Text("키워드 입력")
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () async {
                    _inputKeywordText = _inputKeywordText.trim();

                    // 오류 출력시 메세지
                    String? toastMsg;

                    // TODO :: 정규식 검사로 변경
                    // 입력 내용 유효성 검사
                    if(_inputKeywordText == "") {
                      toastMsg = "유효하지 않은 입력입니다.";
                    } else {
                      // TODO :: DB 데이터 중복 검사
                      // 중복 검사 :: DB 접근 횟수를 줄이기 위해 프론트에서 임시로 처리함
                      for(KeywordModel model in keywordListState) {
                        if(model.keyword == _inputKeywordText) {
                          toastMsg = "이미 등록된 키워드입니다.";
                        }
                      }
                    }

                    // 오류 처리
                    if(toastMsg != null) {
                      // 오류 메세지 출력(토스트)
                      Fluttertoast.showToast(msg: toastMsg);
                      // 입력 내용 초기화
                      _inputKeywordText = "";
                      // 새로고침 :: inputFormField의 값을 초기화하기 위해
                      setState(() {
                        _reflash = true;
                      });
                      return;
                    }

                    // keyword textFormField의 내용을 키워드로 DB에 저장
                    _keywordRepository.create(KeywordModel(keyword: _inputKeywordText, userUid: ref.read(userProvider)!.userModelId, useYn: true));
                    // 입력 내용 초기화
                    _inputKeywordText = "";
                    // 키워드 목록 다시 조회
                    ref.read(keywordListProvider.notifier).readList();
                  },
                  child: const Text("등록"),
                ),
              )
            ],
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("설정된 키워드 목록", textAlign: TextAlign.left),
                Row(
                  children: [
                    ...keywordListWidgets,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

// 키워드 목록 위젯
class KeywordItem extends StatelessWidget {
  final KeywordModel keywordModel;
  final Function? onDeletedCallback;

  KeywordItem({required this.keywordModel, this.onDeletedCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlinedButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text("키워드를 삭제 하시겠습니까?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // TODO :: 키워드 삭제 동작
                        KeywordRepository().delete(keywordModel);
                        // 키워드 목록 다시 조회
                        if(onDeletedCallback != null) {
                          onDeletedCallback!();
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text("예"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("아니요"),
                    ),
                  ],
                );
              },
          );
        },
        child: Text(keywordModel.keyword ?? ""),
      ),
    );
  }

}