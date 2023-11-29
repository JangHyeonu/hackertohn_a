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
      content: ElevatedButton(
        onPressed: () {},
        child: const Text("Google 계정으로 로그인"),
      )
    );
  }
}


