import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteMaskPainter extends CustomPainter {
  final Color color;

  TesArteMaskPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..shader = LinearGradient(
        colors: [
          color,
          color.lighten(percent: .3),
        ],
        stops: [size.width / 2 - 0.01, size.width / 2]
      ).createShader(Rect.fromPoints(
        Offset(0, 0),
        Offset(size.width / 2, size.height),
      ))
      ..style = PaintingStyle.fill;
    final clearPaint = Paint()..blendMode = BlendMode.clear;

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.arcTo(
      Rect.fromLTRB(0, size.height - (size.height / 2), size.width, size.height + (size.height / 4)),
      0,
      pi,
      false
    );

    path.close();

    canvas.saveLayer(Rect.largest, paint);
    canvas.drawPath(path, paint);

    // Eyes 👀
    final Offset firstEyeCenterOffset = Offset((1 - 0.70) * size.width, (1 - 0.60) * size.height);
    final Offset secondEyeCenterOffset = Offset((1 - 0.30) * size.width, (1 - 0.60) * size.height);
    final double eyeRadius = (1 - 0.89) * size.width;

    // Mouth 👄
    final Offset mouthStartOffset = Offset(firstEyeCenterOffset.dx, (1 - 0.15) * size.height);
    final Offset mouthEndOffset = Offset(secondEyeCenterOffset.dx, (1 - 0.10) * size.height);

    canvas.drawOval(Rect.fromCircle(center: firstEyeCenterOffset, radius: eyeRadius), clearPaint);
    canvas.drawOval(Rect.fromCircle(center: secondEyeCenterOffset, radius: eyeRadius), clearPaint);
    canvas.drawRect(Rect.fromPoints(mouthStartOffset, mouthEndOffset), clearPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}