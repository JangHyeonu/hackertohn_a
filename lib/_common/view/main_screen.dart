import 'package:flutter/material.dart';
import 'package:seeya_hackthon_a/_common/component/text_form_button_component.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';

// 메인 화면
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBarLeftUseYn: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 배너
            Container(
              height: MediaQuery.of(context).size.height / 7,
              child: Placeholder(),
            ),
            
            // 행사 리스트
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Placeholder(),
            ),
            
            // 검색창
            Container(
              color: Colors.grey,
              height: MediaQuery.of(context).size.height / 12,
              child: TextFormButtonComponent(
                textFormWidth: MediaQuery.of(context).size.width / 1.8,
                buttonText: "검색",
                buttonClickEvent: () => {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
