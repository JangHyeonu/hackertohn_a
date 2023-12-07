import 'package:flutter/material.dart';
import 'package:seeya_hackthon_a/_common/const/temp_const.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';

class EventDetailScreen extends StatelessWidget {
  final String id;

  const EventDetailScreen({
    required this.id,
    super.key});

  @override
  Widget build(BuildContext context) {
    final data = TempConst.tempListData.firstWhere((element) => element["id"] == id);
    
    return DefaultLayout(
      sideBarOffYn: false,
      child: Column(
        children: [
          Container(
            color: Colors.yellow,
            height: MediaQuery.of(context).size.height / 5,
            width: double.infinity,
            child: Column(
              children: [
                Text(data["title"]!),
                Text(data["date"]!),
                Text(data["distance"]!),
              ],
            ),
          ),
          Container(
            color: Colors.orange,
            height: MediaQuery.of(context).size.height / 1.5,
            width: double.infinity,
            child: Column(
              children: [

              ],
            ),
          ),
        ],
      )
    );
  }
}
