import 'package:flutter/material.dart';

class TextFormButtonComponent extends StatelessWidget {
  final String buttonText;
  final void buttonClickEvent;
  final double textFormWidth;
  final InputDecoration? inputDecoration;

  const TextFormButtonComponent({
    required this.buttonText,
    required this.buttonClickEvent,
    required this.textFormWidth,
    this.inputDecoration,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: TextFormField(
              decoration: inputDecoration,
            ),
            width: textFormWidth,
          ),
          ElevatedButton(
            onPressed: () => buttonClickEvent,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
