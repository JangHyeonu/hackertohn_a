import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/_common/view/join_screen.dart';
import 'package:seeya_hackthon_a/_common/view/main_screen.dart';
import 'package:seeya_hackthon_a/business/view/business_auth_screen.dart';
import 'package:seeya_hackthon_a/business/view/business_join_screen.dart';
import 'package:seeya_hackthon_a/business/view/business_main_screen.dart';
import 'package:seeya_hackthon_a/event/view/event_detail_screen.dart';
import 'package:seeya_hackthon_a/firebase_options.dart';
import 'package:seeya_hackthon_a/user/view/user_join_screen.dart';
import 'package:seeya_hackthon_a/user/view/user_my_page.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  // .env 파일 초기화
  await dotenv.load(fileName: "config.env");

  // 파이어베이스 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //

  // 핸드폰 연결 시 화면 자동꺼짐 방지
  Wakelock.enable();

  runApp(
    // 전역 상태관리를 위해 전체를 ProviderScope로 감싸줌
    const ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get routes => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // 테마 설정
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // 앱바 상단에 debug 마크 지우기
      debugShowCheckedModeBanner: false,

      // 라우팅
      routerConfig: GoRouter(
        initialLocation: "/",
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) => const MainScreen(),
            routes: [
              GoRoute(
                path: "join",
                builder: (context, state) => const JoinScreen(),
                routes: [
                  GoRoute(
                    path: "user",
                    builder: (context, state) => const UserJoinScreen(),
                  ),
                  GoRoute(
                    path: "business",
                    builder: (context, state) => const BusinessJoinScreen(),
                  ),
                ]
              ),
            ]
          ),

          // Event 관련 route
          GoRoute(
            path: "/event/detail/:eventId",
            builder: (context, state) => EventDetailScreen(id: state.pathParameters["eventId"]!),
          ),

          // Login 유저 관련 route
          GoRoute(
            path: "/user",
            builder: (context, state) => const MainScreen(),
            routes: [
              GoRoute(
                  path: "my-page",
                  builder: (context, state) => const UserMyPage(),
              ),
            ]
          ),

          // Login & 사업자 등록 유저 관련 route
          GoRoute(
            path: "/business",
            builder: (context, state) => const BusinessMainScreen(),
            routes: [
              GoRoute(
                path: "auth",
                builder: (context, state) => const BusinessAuthScreen(),
              )
            ]
          ),

        ],
      ),
    );
  }
}
