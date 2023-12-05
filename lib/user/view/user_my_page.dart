import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class UserMyPage extends ConsumerWidget {
  const UserMyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);

    return DefaultLayout(
      appBarLeftUseYn: false,
      child: Container(
        color: Colors.white10,
        child: ListView(
          children: [

            // profile
            Container(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(state!.photoUrl!),
                    ),
                    accountName: Text(state!.displayName!),
                    accountEmail: Text(state!.email!),
                    otherAccountsPictures: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.add_alert), color: Colors.white,)
                    ],
                  ),
                ],
              ),
              // height: MediaQuery.of(context).size.height / 4,
            ),

            // body
            Container(
              child: Column(
                children: [

                  // body-list1
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                            child: Text("나의 활동"),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          tileColor: Colors.grey[200],
                          title: Text("관심 행사"),
                          style: ListTileStyle.drawer,
                        ),
                        ListTile(
                          onTap: () {},
                          tileColor: Colors.grey[200],
                          title: Text("나의 활동 기능 2"),
                        ),
                      ],
                    ),
                  ),

                  // body-list2
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                            child: Text("기타"),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          tileColor: Colors.grey[200],
                          title: Text("내 위치 설정"),
                          style: ListTileStyle.drawer,
                        ),
                        ListTile(
                          onTap: () {},
                          tileColor: Colors.grey[200],
                          title: Text("기타 기능 2"),
                        ),
                      ],
                    ),
                  ),

                  // body-list3
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                            child: Text("소식 및 지원"),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          tileColor: Colors.grey[200],
                          title: Text("자주 묻는 질문"),
                          style: ListTileStyle.drawer,
                        ),
                        ListTile(
                          onTap: () {},
                          tileColor: Colors.grey[200],
                          title: Text("공지사항"),
                        ),
                        ListTile(
                          onTap: () {},
                          tileColor: Colors.grey[200],
                          title: Text("약관 및 정책"),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
