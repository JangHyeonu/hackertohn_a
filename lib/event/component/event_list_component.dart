import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventListComponent extends StatelessWidget {
  final String id;
  final String title;
  final String date;
  final String distance;

  const EventListComponent({
    required this.id,
    required this.title,
    required this.date,
    required this.distance,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title),
          Text(date),
          Text(distance),
        ],
      ),
    );
  }
}
