import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedPaintballPainter extends CustomPainter {
  final Animation<double> animation;
  final int maxBubbles = 10;
  final Color color;
  AnimatedPaintballPainter({required this.animation, required this.color}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Path animationBubblePath = Path();
    animationBubblePath.moveTo(0, 0);
    animationBubblePath.arcToPoint(Offset(size.width, 0), radius: Radius.circular(size.width / 2));
    animationBubblePath.arcToPoint(Offset(size.width, size.height), radius: Radius.circular(size.height / 2));
    animationBubblePath.arcToPoint(Offset(0, size.height), radius: Radius.circular(size.height / 2));
    animationBubblePath.arcToPoint(Offset(0, 0), radius: Radius.circular(size.width / 2));

    final Paint bubblePaint = Paint()..color = color;

    final PathMetric pathMetric = animationBubblePath.computeMetrics().first;

    final double progress = animation.value;
    final double distance = progress * pathMetric.length;
    double radiusBubble = size.width / 6;
    Tangent? tangent = pathMetric.getTangentForOffset(distance);

    if (tangent != null) {
      // 🤯🫧 HEAD BUBBLE:
      canvas.drawCircle(tangent.position, radiusBubble, bubblePaint);

      // 🐍🫧 TAIL BUBBLES:
      for (int i = 1; i < maxBubbles; i++) {
        bubblePaint.color = bubblePaint.color.withAlpha(250 - (i * 16));

        final double newDistance = distance - (i * 6);
        tangent = pathMetric.getTangentForOffset(newDistance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, radiusBubble - i * 2, bubblePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}