import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final double size;
  final Color color;

  TextIcon(
      {Key? key,
      required this.iconData,
      required this.text,
      this.size = 13,
      this.color = Colors.black87})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: size,
          color: color,
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            "$text",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: size, color: color),
          ),
        ),
      ],
    );
  }
}
