import 'package:flutter/material.dart';

class TitleText {
  static Widget titleText(String label, String text, double size) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(fontSize: size, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// Sử dụng:
// CustomRichText.buildRichText('Mã khu vực', area['code'], 16); -> Mã khu vực: 123 fontSize 16
