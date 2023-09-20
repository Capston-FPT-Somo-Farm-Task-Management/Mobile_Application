import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final Color iconColor, backgroundIconColor;

  const Option({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Thay đổi màu sắc tại đây nếu cần
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            /// Container cho biểu tượng
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: backgroundIconColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                color: iconColor, // Thay đổi màu sắc tại đây nếu cần
              ),
            ),

            /// Cho khoảng cách
            const SizedBox(
              width: 24,
            ),

            /// Cho văn bản
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: Colors.grey, // Thay đổi màu sắc tại đây nếu cần
              ),
            ),

            const Spacer(),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
