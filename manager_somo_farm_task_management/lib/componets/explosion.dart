import 'package:flutter/material.dart';

class ExplosionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Vẽ các đoạn thẳng chéo tạo hiệu ứng nhọn
    canvas.drawLine(Offset(centerX, centerY - radius),
        Offset(centerX, centerY - radius - 8), paint);
    canvas.drawLine(Offset(centerX, centerY + radius),
        Offset(centerX, centerY + radius + 8), paint);
    canvas.drawLine(Offset(centerX - radius, centerY),
        Offset(centerX - radius - 8, centerY), paint);
    canvas.drawLine(Offset(centerX + radius, centerY),
        Offset(centerX + radius + 8, centerY), paint);

    canvas.drawLine(Offset(centerX - radius / 1.4, centerY - radius / 1.4),
        Offset(centerX - radius / 1.4 - 5, centerY - radius / 1.4 - 5), paint);

    canvas.drawLine(Offset(centerX + radius / 1.4, centerY - radius / 1.4),
        Offset(centerX + radius / 1.4 + 5, centerY - radius / 1.4 - 5), paint);

    canvas.drawLine(Offset(centerX - radius / 1.4, centerY + radius / 1.4),
        Offset(centerX - radius / 1.4 - 5, centerY + radius / 1.4 + 5), paint);

    canvas.drawLine(Offset(centerX + radius / 1.4, centerY + radius / 1.4),
        Offset(centerX + radius / 1.4 + 5, centerY + radius / 1.4 + 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
