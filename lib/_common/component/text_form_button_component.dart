import 'package:flutter/material.dart';

class TextFormButtonComponent extends StatelessWidget {
  final String buttonText;
  final void buttonClickEvent;
  final double textFormWidth;

  const TextFormButtonComponent({
    required this.buttonText,
    required this.buttonClickEvent,
    required this.textFormWidth,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: TextFormField(),
          width: textFormWidth,
        ),
        ElevatedButton(
          onPressed: () => buttonClickEvent,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
