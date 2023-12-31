

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/firebse_messaging/custom_firebase_messaging.dart';
import 'package:seeya_hackthon_a/_common/geolocator/custom_geolocator.dart';
import 'package:seeya_hackthon_a/_common/view/join_screen.dart';
import 'package:seeya_hackthon_a/alarm/view/alarm_list_screen.dart';
import 'package:seeya_hackthon_a/business/view/business_auth_screen.dart';
import 'package:seeya_hackthon_a/business/view/business_join_screen.dart';
import 'package:seeya_hackthon_a/business/view/business_main_screen.dart';
import 'package:seeya_hackthon_a/event/view/event_detail_screen.dart';
import 'package:seeya_hackthon_a/event/view/event_edit_screen.dart';
import 'package:seeya_hackthon_a/event/view/event_list_screen.dart';
import 'package:seeya_hackthon_a/event/view/event_my_list_screen.dart';
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

  // 핸드폰 연결 시 화면 자동꺼짐 방지
  Wakelock.enable();

  // geolocator 권한 요청
  await CustomGeolocator.requestGeolocatorPermission();

  // firebase messaging 권한 요청 및 초기 설정
  await CustomFirebaseMessaging.requestPermissionAndInit();

  runApp(
    // 전역 상태관리를 위해 전체를 ProviderScope로 감싸줌
    const ProviderScope(
      child: MyApp(),
    ),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffF8EDEB)),
        useMaterial3: true,
      ),

      // 앱바 상단에 debug 마크 지우기
      debugShowCheckedModeBanner: false,

      // 라우팅
      routerConfig: GoRouter(
        initialLocation: "/",
        debugLogDiagnostics: true,
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) => EventListScreen(),
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
            path: "/event",
            builder: (context, state) => const EventListScreen(),
            routes: [
              GoRoute(
                path: "list",
                builder: (context, state) => const EventListScreen(),
              ),
              GoRoute(
                path: "myList",
                builder: (context, state) => EventMyListScreen(),
              ),
              GoRoute(
                path: "edit",
                builder: (context, state) => EventEditScreen(),
              ),
              GoRoute(
                path: "edit/:eventId",
                builder: (context, state) => EventEditScreen(eventId: state.pathParameters["eventId"]!),
              ),
              GoRoute(
                path: "detail/:eventId",
                builder: (context, state) {
                  if(state.pathParameters["eventId"] == null) {
                    context.push("/event/list");
                  }
                  return EventDetailScreen(eventId: state.pathParameters["eventId"]!);
                },
                // builder: (context, state) => EventDetailScreen(id: state.pathParameters["eventId"]!),
              ),
            ]
          ),
          // Login 유저 관련 route
          GoRoute(
            path: "/user",
            // TODO :: (임시처리함) 현재 이 주소로 연결될 페이지가 없으므로 이벤트 목록 페이지에 연결해 둠
            // builder: (context, state) => EventListScreen(pageNo: 1),
            builder: (context, state) => EventListScreen(),
            // builder: (context, state) => const MainScreen(),
            routes: [
              GoRoute(
                path: "my-page",
                builder: (context, state) => const UserMyPage(),
              ),
              GoRoute(
                path: "alarm",
                builder: (context, state) => AlarmListScreen(),
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
                builder: (context, state) => BusinessAuthScreen(),
              )
            ]
          ),

        ],
      ),
    );
  }
}
