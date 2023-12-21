import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/view/login_popup_screen.dart';
import 'package:seeya_hackthon_a/business/provider/business_provider.dart';
import 'package:seeya_hackthon_a/user/model/user_model.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

import '../firebse_messaging/custom_firebase_messaging.dart';

// 상단의 앱바를 포함한 기본 레이아웃
class DefaultLayout extends ConsumerStatefulWidget {
  final bool sideBarOffYn;
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final bool? isResize;
  final Widget? bottomSheetWidget;

  const DefaultLayout(
      {required this.sideBarOffYn, required this.child, this.backgroundColor, this.title, this.isResize, this.bottomSheetWidget, super.key});

  @override
  ConsumerState<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends ConsumerState<DefaultLayout> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title ?? ""),
        centerTitle: true,
      ),
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset : widget.isResize,
      bottomSheet: widget.bottomSheetWidget,

      // 앱바 우측 상단 리스트바 메뉴
      endDrawer: !widget.sideBarOffYn ? Drawer(
        child: ListView(
          children: <Widget>[
            drawerHeader(state),
            (state == null || state.email == "" ?
              TextButton(
                child: const Text("로그인"),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const LoginPopupScreen(),
                  );
                },
              )
                :
              TextButton(
                child: const Text("로그아웃"),
                onPressed: () {
                  ref.read(userProvider.notifier).logout();

                  Fluttertoast.showToast(
                      msg: "로그아웃",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.white
                  );
                },
              )
            ),
            drawerBody(state),
          ],
        ),
      ) : null,
      body: widget.child,
    );
  }

  UserAccountsDrawerHeader drawerHeader(UserModel? state) {
    if(state == null || state.email == "") {
      return const UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage("assets/image/temp_user.png"),
        ),
        accountName: Text("guest"),
        accountEmail: Text("guest@email.com"),
      );
    } else {
      return UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(state!.photoUrl!),
        ),
        accountName: Text(state!.displayName!),
        accountEmail: Text(state!.email!),
        otherAccountsPictures: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_active), color: Colors.white)
        ],
      );
    }
  }

  // 사이드바 홈화면 (     ) 설정 사이의 리스트 추가를 위함
  Widget drawerBody(UserModel? state) {
    List<Widget> customColumn = List.empty();

    if(!(state == null || state.email == "")) {
      customColumn = [
        ListTile(
          leading: const Icon(Icons.add_alert_rounded),
          title: const Text('나의 알림'),
          onTap: () {
            context.go("/user/alarm");
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('마이 페이지'),
          onTap: () {
            context.go("/user/my-page");
          },
        ),
        state.auth == "business" ?
          ExpansionTile(
            title: const Text('나의 행사'),
            shape: InputBorder.none,
            leading: const Icon(Icons.business),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.playlist_add),
                      title: const Text('등록 행사 목록'),
                      onTap: () {
                        context.go("/event/regEventList");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.playlist_add),
                      title: const Text('행사 등록'),
                      onTap: () {
                        context.go("/event/edit");
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(),
      ];
    }

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('홈 화면'),
          onTap: () {
            while(context.canPop()) {
              context.pop();
            }
            context.go("/");
          },
        ),
        ...customColumn,
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('설정'),
          onTap: () => {},
        ),
      ],
    );
  }
}
