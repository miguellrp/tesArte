import 'package:flutter/material.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteTooltipText extends StatelessWidget {
  final String? text;

  final double padding;
  final double maxWidth;

  const TesArteTooltipText({
    super.key,
    required this.text,

    this.padding = 22,
    this.maxWidth = 300
  });

  double get width {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: TextTheme.of(navigatorKey.currentContext!).bodyMedium),
    )..layout(maxWidth: maxWidth);

    return textPainter.width + padding;
  }

  double get height {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: TextTheme.of(navigatorKey.currentContext!).bodyMedium),
    )..layout(maxWidth: maxWidth);

    return textPainter.height + (padding - (padding * .55));
  }


  SizedBox _getTooltipText(BuildContext context) {
    late SizedBox tooltipText;

    if (text.isNotEmptyAndNotNull) {
      TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: text,
          style: TextTheme.of(context).bodyMedium
        )
      )..layout(maxWidth: maxWidth);

      tooltipText = SizedBox(
        width: textPainter.width + padding,
        height: textPainter.height + (padding - (padding * .55)),
        child: CustomPaint(
          painter: TesArteTooltipTextPainter(textPainter: textPainter, padding: padding),
        )
      );
    } else {
      tooltipText = SizedBox.shrink();
    }

    return tooltipText;
  }

  @override
  Widget build(BuildContext context) {
    return _getTooltipText(context);
  }
}

class TesArteTooltipTextPainter extends CustomPainter {
  TesArteTooltipTextPainter({required this.textPainter, required this.padding});

  final TextPainter textPainter;
  final double padding;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final Rect rect = Rect.fromPoints(Offset.zero, Offset(textPainter.width + padding, textPainter.height + (padding - (padding * .55))));

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)), paint);

    textPainter.paint(canvas, Offset(padding / 2, (padding - (padding * .55)) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}