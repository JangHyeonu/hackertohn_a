import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            onPressed: () {},
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


