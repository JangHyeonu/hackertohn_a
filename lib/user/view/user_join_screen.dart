import 'package:flutter/cupertino.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';

class UserJoinScreen extends StatelessWidget {
  const UserJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      sideBarOffYn: false,
      child: Center(
        child: Text("UserJoin"),
      ),
    );
  }
}
