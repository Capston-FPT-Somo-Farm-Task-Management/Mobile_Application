import 'package:flutter/material.dart';

class Priority {
  static Color getBGClr(String no) {
    switch (no) {
      case "Thấp nhất":
        return Color.fromARGB(255, 39, 124, 161);
      case "Thấp":
        return const Color(0xFF90BE6D);
      case "Trung bình":
        return Color.fromARGB(255, 198, 162, 78);
      case "Cao":
        return Color.fromARGB(255, 244, 128, 66);
      case "Cao nhất":
        return const Color(0xFFF94144);
      default:
        return Colors.transparent;
    }
  }
}
