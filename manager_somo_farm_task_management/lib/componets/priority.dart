import 'package:flutter/material.dart';

class Priority {
  static Color getBGClr(String no) {
    switch (no) {
      case "Thấp nhất":
        return const Color(0xFF277DA1);
      case "Thấp":
        return const Color(0xFF90BE6D);
      case "Trung bình":
        return const Color(0xFFF9C74F);
      case "Cao":
        return const Color(0xFFF3722C);
      case "Cao nhất":
        return const Color(0xFFF94144);
      default:
        return Colors.transparent;
    }
  }
}
