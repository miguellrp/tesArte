import 'dart:math';
import 'package:flutter/material.dart';

class TheaterMaskPainter extends CustomPainter {
  final Color color;

  TheaterMaskPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.arcTo(
      Rect.fromLTRB(0, size.height - 50, size.width, size.height + 10),
      0,
      pi,
      false
    );

    path.close();
    canvas.drawPath(path, paint);

    final Paint eyesStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawOval(Rect.fromCircle(center: Offset(12, 20), radius: 5), eyesStroke);
    canvas.drawOval(Rect.fromCircle(center: Offset(32, 20), radius: 5), eyesStroke);
    canvas.drawRect(Rect.fromPoints(Offset(12, 38), Offset(32, 40)), eyesStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}