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
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title),
          Text((startDatetime != null) ? DateFormat("yyyy.MM.dd").format(startDatetime!) : "-"),
          //Text(distance),
        ],
      ),
    );
  }
}
