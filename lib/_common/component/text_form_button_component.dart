import 'package:flutter/material.dart';

class TextFormButtonComponent extends StatelessWidget {
  final String buttonText;
  final Function() buttonClickEvent;
  final double textFormWidth;
  final InputDecoration? inputDecoration;
  final FocusNode? focusNode;

  const TextFormButtonComponent({
    required this.buttonText,
    required this.buttonClickEvent,
    required this.textFormWidth,
    this.inputDecoration,
    this.focusNode,
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
            width: textFormWidth,
            child: TextFormField(
              focusNode: focusNode,
              decoration: inputDecoration,
            ),
          ),
          ElevatedButton(
            onPressed: buttonClickEvent,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
