import 'package:flutter/material.dart';

class IconWithTextButtonComponent extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconWithTextButtonComponent({
    required this.icon,
    required this.text,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        child: InkWell(
          onTap: () {},
          child: Ink(
            width: MediaQuery.of(context).size.width / 2,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 50),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
