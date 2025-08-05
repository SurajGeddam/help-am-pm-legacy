import 'package:flutter/material.dart';

class AppDottedLineWidget extends CustomPainter {
  final bool isDottedLineVertical;
  final Color color;
  final int dashHeight;
  final int dashWidth;
  final int dashSpace;

  const AppDottedLineWidget({
    Key? key,
    this.isDottedLineVertical = false,
    this.color = Colors.black,
    this.dashHeight = 4,
    this.dashWidth = 4,
    this.dashSpace = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 1;

    _drawDashedLine(canvas, paint, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Size size) {
    // Start to draw from left size.
    // Of course, you can change it to match your requirement.
    double startX = 0;
    double startY = 0;

    double x = 0;
    double y = 0;

    if (isDottedLineVertical) {
      // Repeat drawing until we reach the right edge.
      while (startY < size.height) {
        // Draw a small line.
        canvas.drawLine(
            Offset(x, startY), Offset(x, startY + dashHeight), paint);

        // Update the starting Y
        startY += dashHeight + dashSpace;
      }
    } else {
      // Repeat drawing until we reach the right edge.
      while (startX < size.width) {
        // Draw a small line.
        canvas.drawLine(
            Offset(startX, y), Offset(startX + dashWidth, y), paint);

        // Update the starting X
        startX += dashWidth + dashSpace;
      }
    }
  }
}
