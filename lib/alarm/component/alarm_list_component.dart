
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
    return Row(
      children: [
        const Icon(Icons.access_alarms_sharp),
        Text(message ?? "", overflow: TextOverflow.ellipsis),
      ],
    );
  }

}