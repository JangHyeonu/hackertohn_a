
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

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xfff9e2c5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 키워드입력, 등록
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
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
                            border: InputBorder.none,
                            icon: Icon(Icons.text_fields),
                            label: Text("키워드 입력"),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0x30f9e2c5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
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
                            child: const Text("등록", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // 설정된 키워드 목록
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white38,
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 키워드 목록 텍스트
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 12.0),
                      child: Text("설정된 키워드 목록",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    // 키워드
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: [
                          ...keywordListWidgets,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}

// 키워드 목록 위젯
class KeywordItem extends StatelessWidget {
  final KeywordModel keywordModel;
  final Function? onDeletedCallback;

  const KeywordItem({super.key, required this.keywordModel, this.onDeletedCallback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 30,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsPadding: const EdgeInsets.all(8),
                  contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  content: Row(
                    children: [
                      Text(keywordModel.keyword ?? "", style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      const Text(" 키워드를 삭제 하시겠습니까?"),
                    ],
                  ),
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
        child: Text(keywordModel.keyword ?? "",
          style: const TextStyle(
            fontSize: 10,
          ),
        ),
      ),
    );
  }

}