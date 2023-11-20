import 'package:flutter/material.dart';

Widget buildOptionTask(IconData icon, String text, Color? textColor) {
  return Container(
    color: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: Row(
      children: [
        Icon(icon, color: textColor),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}
