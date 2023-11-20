import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonConfirmText;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.buttonConfirmText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng hộp thoại
          },
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Gọi hàm xác nhận
            Navigator.of(context).pop(); // Đóng hộp thoại sau khi xóa
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.blue,
            child: Text(
              buttonConfirmText,
              style: const TextStyle(color: kBackgroundColor),
            ),
          ),
        ),
      ],
    );
  }
}
