import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class ConfirmDeleteDialog extends StatefulWidget {
  final String title;
  final String content;
  final String buttonConfirmText;
  final VoidCallback onConfirm;
  final bool? checkBox;
  final ValueChanged<bool>? onCheckBoxChanged;
  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.buttonConfirmText,
    this.checkBox,
    this.onCheckBoxChanged,
  });

  @override
  State<ConfirmDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {
  bool isImportant = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: IntrinsicHeight(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.content),
              if (widget.checkBox == true)
                Row(
                  children: [
                    Checkbox(
                      value: isImportant,
                      onChanged: (value) {
                        setState(() {
                          isImportant = value!;
                          widget.onCheckBoxChanged?.call(
                              isImportant); // Gọi callback khi giá trị thay đổi
                        });
                      },
                    ),
                    Text('Không cho phép từ chối'),
                  ],
                ),
            ],
          ),
        ),
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
            widget.onConfirm(); // Gọi hàm xác nhận
            Navigator.of(context).pop(); // Đóng hộp thoại sau khi xóa
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.blue,
            child: Text(
              widget.buttonConfirmText,
              style: const TextStyle(color: kBackgroundColor),
            ),
          ),
        ),
      ],
    );
  }
}
