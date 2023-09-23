import 'package:flutter/material.dart';

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
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
          child: Text(
            buttonConfirmText,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }
}
