import 'package:flutter/cupertino.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';

class BusinessMainScreen extends StatelessWidget {
  const BusinessMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      sideBarOffYn: false,
      child: Center(
        child: Text("BusinessMain"),
      ),
    );
  }
}
