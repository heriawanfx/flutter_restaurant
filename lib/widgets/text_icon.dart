import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final double size;

  TextIcon(
      {Key? key, required this.iconData, required this.text, this.size = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: size,
          color: Colors.blueGrey,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          "$text",
          style: TextStyle(fontSize: size),
        ),
      ],
    );
  }
}
