import 'package:flutter/material.dart';

class TitleText {
  static Widget titleText(String label, String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// Sử dụng:
// CustomRichText.buildRichText('Mã khu vực', area['code']); -> Mã khu vực: 123
