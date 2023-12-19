
import 'package:flutter/material.dart';

class AlarmListComponent extends StatelessWidget {

  String? alarmUid;
  DateTime? regDateTime;
  String? message;

  AlarmListComponent({
    this.alarmUid,
    this.regDateTime,
    this.message,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xfff8eeeb),
      ),
      height: MediaQuery.of(context).size.height * 0.6 / 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.height / 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white38,
            ),
            child: const Icon(Icons.access_alarms_sharp),
          ),
          Text(message ?? "", overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

}