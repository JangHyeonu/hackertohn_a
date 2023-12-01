import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:seeya_hackthon_a/_common/auth/google_auth.dart';

class LoginPopupScreen extends StatelessWidget {
  const LoginPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.cancel),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          ElevatedButton(
            onPressed: () async {
              GoogleAuth.signInWithGoogle().then((value) {
                // 로그인 실패
                if(value.user == null) {
                  Fluttertoast.showToast(msg: "로그인 실패");
                  return;
                }

                // 로그인 성공
                Fluttertoast.showToast(
                  msg: "로그인 성공",
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.white
                ).then((value) {
                  if(value != null && value) {
                    if(context.canPop()) {
                      context.pop();
                    }
                  }
                });



              });
            },
            child: const Text("Google 계정으로 로그인"),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.go("/join");
                },
                child: const Text("회원가입"),
              ),
            ],
          ),
        ],
      )
    );
  }
}


