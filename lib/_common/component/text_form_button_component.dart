import 'package:flutter/material.dart';

class TextFormButtonComponent extends StatelessWidget {
  final String? buttonText;
  final Function() buttonClickEvent;
  final Function(String)? onChangeEvent;
  final double textFormWidth;
  final InputDecoration? inputDecoration;
  final FocusNode? focusNode;

  final TextEditingController? textEditingController;

  const TextFormButtonComponent({
    required this.buttonText,
    required this.buttonClickEvent,
    required this.textFormWidth,
    this.onChangeEvent,
    this.inputDecoration,
    this.focusNode,
    this.textEditingController,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: textFormWidth,
            child: TextFormField(
              focusNode: focusNode,
              decoration: inputDecoration,
              onChanged: onChangeEvent,
              controller: textEditingController,
            ),
          ),
          ElevatedButton(
            onPressed: buttonClickEvent,
            child: Text(buttonText ?? "버튼"),
          ),
        ],
      ),
    );
  }

}
