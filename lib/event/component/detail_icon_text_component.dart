import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailIconTextComponent extends StatelessWidget {
  IconData? icon;
  String? title;
  String? content;

  DetailIconTextComponent({
    this.icon,
    this.title,
    this.content,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8.0),
            if(title != null) Text("$title"),
            Text(content ?? ""),
          ],
        ),
      ),
    );
  }
}
