import 'package:flutter/material.dart';

Widget buildDivider() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Divider(
      color: Colors.grey[300],
      height: 1,
      thickness: 1,
    ),
  );
}
