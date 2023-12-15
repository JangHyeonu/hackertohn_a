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
  late var aa = widget.duration!.inSeconds;

  void countDown(bool? tf) {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        aa -= 1;
      });
    });

    if(tf == false) {
      timer.cancel();
      return;
    }
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
    countDown(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hh = (aa / 3600).toInt();
    var mm = ((aa % 3600) / 60).toInt();
    var ss = (aa % 60).toInt();

    return Container(
      child: Text(
        "${hh.abs().toString()}:${mm.abs().toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 2
        ),
      ),
    );
  }
}

