import 'package:flutter/material.dart';

enum TesArteDividerType {
  linear,
  dotted,
}

enum TesArteDividerDirection {
  horizontal,
  vertical
}

class TesArteDivider extends StatelessWidget {
  final TesArteDividerType type;
  final TesArteDividerDirection direction;
  Color? color;

  TesArteDivider({super.key, this.color, this.type = TesArteDividerType.linear, this.direction = TesArteDividerDirection.horizontal});

  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).colorScheme.primary.withAlpha(150);

    switch (type) {
      case TesArteDividerType.linear: return LinearDivider(direction: direction);
      case TesArteDividerType.dotted: return DottedDivider(direction: direction);
    }
  }
}


/* --- LINEAR DIVIDER --- */
class LinearDivider extends StatelessWidget {
  final TesArteDividerDirection direction;

  const LinearDivider({super.key, this.direction = TesArteDividerDirection.horizontal});
  @override
  Widget build(BuildContext context) {
    return direction == TesArteDividerDirection.horizontal ? Divider(
      color: Theme.of(context).colorScheme.primary.withAlpha(150),
      thickness: 2,
      height: 0,
      indent: 50,
      endIndent: 50,
    ) : VerticalDivider(
      color: Theme.of(context).colorScheme.primary.withAlpha(150),
      thickness: 2,
      width: 0,
      indent: 120,
      endIndent: 120,
    );
  }
}

// TODO: CHECK STARTINGX POINT
/* --- DOTTED DIVIDER --- */
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withAlpha(150)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2;

    double startX = -150;

    while(startX < 150) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + 5, 0), paint);
      startX += 10;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedDivider extends StatelessWidget {
  final TesArteDividerDirection direction;

  const DottedDivider({super.key, this.direction = TesArteDividerDirection.horizontal});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: DottedLinePainter(),
        child: SizedBox.shrink()
      ),
    );
  }
}

