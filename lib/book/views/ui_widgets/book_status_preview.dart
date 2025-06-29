import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/book/utils/book/util_book.dart';

class BookStatusPreview extends StatelessWidget {
  final int? status;

  const BookStatusPreview({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: UtilBook.getStatusText(status),
      child: CustomPaint(
        painter: BookStatusPreviewPainter(color: UtilBook.getStatusColor(status)),
        size: Size(22, 26),
      ),
    );
  }
}


class BookStatusPreviewPainter extends CustomPainter {
  final Color color;

  BookStatusPreviewPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..color = color.darken(percent: .2)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    Path path = Path();

    /* Left side of bookmark */
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height - (size.height * 0.3));
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
    path.reset();

    /* Right side of bookmark */
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height - (size.height * 0.3));
    path.lineTo(size.width / 2, 0);

    canvas.drawPath(path, paint..color = color.lighten(percent: .4));
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}