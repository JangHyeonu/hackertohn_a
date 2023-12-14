
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeywordComponent extends ConsumerStatefulWidget {
  const KeywordComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() { return KeywordComponentState(); }
}

class KeywordComponentState extends ConsumerState<KeywordComponent> {

  KeywordComponentState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                margin: const EdgeInsets.only(left: 20, right: 10),
                child: TextFormField(
                  onChanged: (value) {
                    // TODO :: 입력 받은 값으로 기존 키워드 검색 후 키워드 목록 선택지 출력 => 선택한 키워드로 값 대체
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
                  onPressed: () {
                    // TODO :: keyword textFormField의 내용을 키워드로 DB에 저장
                  },
                  child: const Text("등록"),
                ),
              )
            ],
          ),
          const Text("설정된 키워드 목록"),
          Stack(
            children: [

            ],
          )
        ],
      ),
    );
  }

}