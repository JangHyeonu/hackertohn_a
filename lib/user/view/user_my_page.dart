import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/business/provider/business_provider.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class UserMyPage extends ConsumerWidget {
  const UserMyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    final businessState = ref.watch(businessProvider);

    return DefaultLayout(
      sideBarOffYn: false,
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
                      state.businessModel?.applyState == "approve" ?
                        IconButton(onPressed: (){}, icon: const Icon(Icons.business), color: Colors.white)
                          : IconButton(onPressed: (){}, icon: const Icon(Icons.person), color: Colors.white),
                    ],
                  ),
                ],
              ),
              // height: MediaQuery.of(context).size.height / 4,
            ),

            // Container(
            //   color: Colors.white24,
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           CircleAvatar(backgroundImage: NetworkImage(state!.photoUrl!)),
            //           Column(
            //             children: [
            //               IconButton(onPressed: (){}, icon: Icon(Icons.person)),
            //               Text("일반사용자"),
            //             ],
            //           ),
            //           SizedBox(width: 8.0,),
            //           Column(
            //             children: [
            //               IconButton(onPressed: (){}, icon: Icon(Icons.business)),
            //               Text("사업자"),
            //             ],
            //           )
            //         ],
            //       ),
            //       Text(state!.displayName!),
            //       Text(state!.email!)
            //     ],
            //   ),
            //   // height: MediaQuery.of(context).size.height / 4,
            // ),

            // body
            Container(
              child: Column(
                children: [

                  ListTile(
                    onTap: () {
                      if(state.businessModel?.applyState == "approve") {
                        Fluttertoast.showToast(
                            msg: "이미 인증된 계정입니다.\n(사업자 추가 등록은 추후 구현)",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.white
                        );
                        return;
                      }

                      if(businessState.applyState == "apply") {
                        Fluttertoast.showToast(
                            msg: "신청서가 접수되어 인증이 진행 중입니다.",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.white
                        );
                        return;
                      }

                      context.push("/business/auth");
                    },
                    tileColor: Colors.grey[200],
                    title: Text("사업자 계정 인증"),
                    subtitle: Text("사업자를 인증하면 행사를 등록할 수 있어요"),
                    style: ListTileStyle.drawer,
                  ),
                  SizedBox(height: 8.0,),

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
                          title: Text("기능 2"),
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
                          title: Text("기능 2"),
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
