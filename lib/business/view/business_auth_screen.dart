import 'package:flutter/material.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';

class BusinessAuthScreen extends StatelessWidget {
  const BusinessAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      sideBarOffYn: true,
      title: "사업자 계정 인증",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {

              },
              decoration: InputDecoration(
                icon: Icon(Icons.photo),
                label: Text("사업자등록증"),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.25,
              child: Placeholder(),
            ),

            TextFormField(
              onChanged: (value) {

              },
              decoration: InputDecoration(
                icon: Icon(Icons.abc),
                label: Text("상호명"),
              ),
            ),
            TextFormField(
              onChanged: (value) {

              },
              decoration: InputDecoration(
                icon: Icon(Icons.abc),
                label: Text("업종"),
              ),
            ),
            TextFormField(
              onChanged: (value) {

              },
              decoration: InputDecoration(
                icon: Icon(Icons.abc),
                label: Text("대표자명"),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){}, child: Text("취소")),
                const SizedBox(width: 8.0),
                ElevatedButton(onPressed: (){}, child: Text("인증 신청"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
