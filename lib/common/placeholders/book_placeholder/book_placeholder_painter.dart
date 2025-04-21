import 'package:flutter/material.dart';

class BookPlaceholderPainter extends CustomPainter {
  final Color color;

  BookPlaceholderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final clearPaint = Paint()..blendMode = BlendMode.clear;

    canvas.saveLayer(Rect.largest, paint);

    /* Background */
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      paint
    );

    /* First line */
    Map<String, dynamic> lineLTRBRPoints = {
      "l": (1 - 0.70) * size.width,
      "t": (1 - 0.83) * size.height,
      "r": (1 - 0.30) * size.width,
      "b": (1 - 0.78) * size.height,
      "radius": Radius.circular(12)
    };

    canvas.drawRRect(
        RRect.fromLTRBR(lineLTRBRPoints["l"]!, lineLTRBRPoints["t"]!, lineLTRBRPoints["r"]!, lineLTRBRPoints["b"]!, lineLTRBRPoints["radius"]!),
        clearPaint
    );

    canvas.drawRRect(
      RRect.fromLTRBR(lineLTRBRPoints["l"]!, lineLTRBRPoints["t"]!, lineLTRBRPoints["r"]!, lineLTRBRPoints["b"]!, lineLTRBRPoints["radius"]!),
      paint..color = color.withAlpha(150)
    );

    /* Second line */
    lineLTRBRPoints["l"] = (1 - 0.85) * size.width;
    lineLTRBRPoints["t"] = (1 - 0.68) * size.height;
    lineLTRBRPoints["r"] = (1 - 0.15) * size.width;
    lineLTRBRPoints["b"] = (1 - 0.73) * size.height;

    canvas.drawRRect(
        RRect.fromLTRBR(lineLTRBRPoints["l"], lineLTRBRPoints["t"], lineLTRBRPoints["r"], lineLTRBRPoints["b"], Radius.circular(12)),
        clearPaint
    );

    canvas.drawRRect(
        RRect.fromLTRBR(lineLTRBRPoints["l"], lineLTRBRPoints["t"], lineLTRBRPoints["r"], lineLTRBRPoints["b"], Radius.circular(12)),
        paint..color = color.withAlpha(150)
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}