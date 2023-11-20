import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';

Widget buildIconOption(IconData icon, String label) {
  return Container(
    width: 75,
    height: 115,
    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Icon(icon),
        ),
        SizedBox(height: 10),
        Text(
          wrapWordsWithEllipsis(label, 18),
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
