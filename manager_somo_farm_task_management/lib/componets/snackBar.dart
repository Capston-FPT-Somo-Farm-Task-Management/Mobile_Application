import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';


class SnackbarShowNoti {
  static void showSnackbar(
      BuildContext context, String message, bool isWarning) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          isWarning
              ? const Icon(
                  Icons.error,
                  color: Colors.red, // Màu của biểu tượng cảnh báo
                )
              : const Icon(
                  Icons.check_circle,
                  color: kPrimaryColor, // Màu của biểu tượng thanh cong
                ),
          const SizedBox(width: 8), // Khoảng cách giữa biểu tượng và nội dung
          Text(
            message,
            style: isWarning
                ? const TextStyle(
                    color: Colors.red, fontSize: 15 // Màu của nội dung
                    )
                : const TextStyle(
                    color: kPrimaryColor, // Màu của nội dung
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Màu nền của Snackbar
    );

    // Hiển thị Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
