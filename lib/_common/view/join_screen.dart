import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/component/icon_with_text_button_component.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBarLeftUseYn: false,
      backgroundColor: Colors.grey[200],
      child: Row(
        children: [
          IconWithTextButtonComponent(
            icon: Icons.person,
            text: "개인 회원 가입",
            onTab: () {
              print("a");
              context.go("/join/user");
            },
          ),
          IconWithTextButtonComponent(
            icon: Icons.business,
            text: "사업자 회원 가입",
            onTab: () {
              context.go("/join/business");
            },
          ),
        ],
      ),
    );
  }
}
