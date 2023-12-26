import 'dart:async';
import 'dart:ui';

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
  String? keyword;

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
    this.keyword,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
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
                        dday(startDatetime ?? DateTime.now(), endDatetime!),
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.25
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                EventListComponentCounter(startDatetime: startDatetime!, endDatetime: endDatetime ?? DateTime.now()),
                // Text(distance),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    businessTitle != null ? businessTitle! : "-",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blueGrey,
                    )
                  ),
                  padding: const EdgeInsets.fromLTRB(6.0,1.5,6.0,1.5),
                  child: Text(splitKeyword(keyword), style: const TextStyle(color: Colors.blueGrey, fontSize: 10, fontWeight: FontWeight.w500)),
                ),
                Expanded(child: Container()),
                Text((startDatetime != null) ? "${DateFormat("yyyy.MM.dd").format(startDatetime!)} ~ " : "-"),
                Text((endDatetime != null) ? DateFormat("yyyy.MM.dd").format(endDatetime!) : "-"),
              ],
            )
          ],
        ),
      ),
    );
  }

  String splitKeyword(String? keyword) {
    if(keyword == null) {
      return "";
    }

    String returnStr = "";
    List<String> keywordList = keyword.split(",");
    returnStr = keywordList[0];

    return "# $returnStr";
  }

  String dday(DateTime startDatetime, DateTime endDatetime) {
    DateTime startday = startDatetime;
    DateTime endday = endDatetime;
    DateTime today = DateTime.now();

    DateFormat formatter = DateFormat("yyyy-MM-dd");

    String formattedStartday = formatter.format(startday);
    String formattedToday = formatter.format(today);

    String strDday;
    // if(formattedStartday == formattedToday) {
    if(today.isAfter(startday) && today.isBefore(endday)) {
      strDday = "D-day!";
    } else {
      Duration duration = endday.difference(today);
      int dayDiff = duration.inDays + 1;
      strDday = "D-$dayDiff";
    }

    return strDday;
  }

}

class EventListComponentCounter extends StatefulWidget {
  DateTime endDatetime;
  DateTime startDatetime;
  DateTime nowDatetime = DateTime.now();
  Duration? duration;

  EventListComponentCounter({
    super.key,
    required this.startDatetime,
    required this.endDatetime,
  }) {
    duration = nowDatetime.difference(endDatetime);
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
      widget.nowDatetime.isAfter(widget.startDatetime) && widget.nowDatetime.isBefore(widget.endDatetime) ?
      Container(
        child: Text(
          "${hh.abs().toString()}:${mm.abs().toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")} 남음",
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

