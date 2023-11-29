import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/view/login_popup_screen.dart';

// 상단의 앱바를 포함한 기본 레이아웃
class DefaultLayout extends StatelessWidget {
  final bool appBarLeftUseYn;
  final Widget child;

  const DefaultLayout(
      {required this.appBarLeftUseYn, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      
      // 앱바 우측 상단 리스트바 메뉴
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/image/temp_user.png"),
              ),
              accountName: Text("임시계정명"),
              accountEmail: Text("임시계정@google.com"),
            ),
            TextButton(
              child: const Text("로그인"),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const LoginPopupScreen(),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈 화면'),
              onTap: () {
                if(context.canPop()) {
                  context.pop();
                }
                context.go("/");
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_alert_rounded),
              title: const Text('나의 알림'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('마이 페이지'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('설정'),
              onTap: () => {},
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
