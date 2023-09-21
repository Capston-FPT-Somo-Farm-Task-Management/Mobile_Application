import 'package:flutter/material.dart';

class Priority {
  static String getPriority(int no) {
    switch (no) {
      case 1:
        return "Thấp nhất";
      case 2:
        return "Thấp";
      case 3:
        return "Trung bình";
      case 4:
        return "Cao";
      case 5:
        return "Cao nhất";
      default:
        return "Không xác định";
    }
  }

  static Color getBGClr(int no) {
    switch (no) {
      case 1:
        return const Color(0xFF277DA1);
      case 2:
        return const Color(0xFF90BE6D);
      case 3:
        return const Color(0xFFF9C74F);
      case 4:
        return const Color(0xFFF3722C);
      case 5:
        return const Color(0xFFF94144);
      default:
        return Colors.transparent;
    }
  }
}
