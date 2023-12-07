import 'package:flutter/cupertino.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';

class BusinessJoinScreen extends StatelessWidget {
  const BusinessJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      sideBarOffYn: false,
      child: Center(
        child: Text("BusinessJoin"),
      ),
    );
  }
}
