import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListComponent extends StatelessWidget {
  String eventId;
  String title;
  String? content;
  String? location;
  DateTime? startDatetime;
  DateTime? endDatetime;
  String? caution;

  String? businessTitle;
  DateTime? regDatetime;

  EventListComponent({
    required this.eventId,
    required this.title,
    this.content,
    this.location,
    this.startDatetime,
    this.endDatetime,
    this.caution,
    this.businessTitle,
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
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.fromLTRB(8,2,8,2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white70,
                  ),
                  // color: Colors.white,
                  child: Text(
                    dday(startDatetime ?? DateTime.now()),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.25
                    ),
                  ),
                ),
                Expanded(child: Container()),
                // EventListComponentCounter(startDatetime: startDatetime ?? DateTime.now()),
                // Text(distance),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white70,
                  ),
                  padding: EdgeInsets.fromLTRB(6,3,6,3),
                  child: Text(
                    businessTitle != null ? businessTitle! : "-",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                    ),
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((startDatetime != null) ? DateFormat("yyyy.MM.dd").format(startDatetime!) : "-"),
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

    DateFormat formatter = DateFormat("yyyy-MM-dd");

    String formattedStartday = formatter.format(startday);
    String formattedToday = formatter.format(today);

    String strDday;
    if(formattedStartday == formattedToday) {
      strDday = "D-day!";
    } else {
      Duration duration = startday.difference(today);
      int dayDiff = duration.inDays + 1;
      strDday = "D-$dayDiff";
    }

    return strDday;
  }

}

class EventListComponentCounter extends StatefulWidget {
  DateTime startDatetime;
  DateTime nowDatetime = DateTime.now();
  Duration? duration;

  EventListComponentCounter({
    Key? key,
    required this.startDatetime,
  }) : super(key: key) {
    duration = nowDatetime.difference(startDatetime);
  }

  @override
  State<EventListComponentCounter> createState() => _EventListComponentCounterState();
}

class _EventListComponentCounterState extends State<EventListComponentCounter> {
  late var bb = widget.duration!.abs().inSeconds;
  late Timer timer;

  void countDown(bool? tf) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(mounted) {
        setState(() {
          bb -= 1;
        });
      }
    });
  }

  void closeCountDown() {
    timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDown(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    closeCountDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hh = bb ~/ 3600;
    var mm = (bb % 3600) ~/ 60;
    var ss = (bb % 60).toInt();

    return
      widget.duration!.abs().inDays < 2 ?
      Container(
        child: Text(
          "${hh.abs().toString()}:${mm.abs().toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 2
          ),
        ),
      ) :
      Container(
        child: const Text(
          "진행 예정",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 2
          ),
        ),
      );
  }
}

