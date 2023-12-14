import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventListComponent extends StatelessWidget {
  String eventId;
  String title;
  String? content;
  String? location;
  DateTime? startDatetime;
  DateTime? endDatetime;
  String? caution;

  String? register;
  DateTime? regDatetime;

  EventListComponent({
    required this.eventId,
    required this.title,
    this.content,
    this.location,
    this.startDatetime,
    this.endDatetime,
    this.caution,
    this.register,
    this.regDatetime,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                //Text(distance),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  register != null ? register! : "-",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((startDatetime != null) ? DateFormat("yyyy.MM.dd").format(startDatetime!) : "-"),
                Text(dday(startDatetime!)),
              ],
            )
          ],
        ),
      ),
    );
  }

  String dday(DateTime startDatetime) {
    DateTime startday = startDatetime;
    DateTime today = DateTime.now();

    Duration duration = startday.difference(today);

    DateTime subtractDatetime = today.subtract(duration);

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String strToday = formatter.format(subtractDatetime);

    return strToday;
  }

}
