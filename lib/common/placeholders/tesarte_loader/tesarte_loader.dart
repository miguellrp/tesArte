import 'package:tesArte/common/placeholders/tesarte_loader/animated_paintball_painter.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_mask_painter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TesArteLoader()));
}

class TesArteLoader extends StatefulWidget {
  @override
  _TesArteLoaderState createState() => _TesArteLoaderState();
}

class _TesArteLoaderState extends State<TesArteLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _loopAnimation;
  late final CurvedAnimation _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();

    _loopAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: TesArteMaskPainter(color: Theme.of(context).colorScheme.primary),
            size: Size(45, 45),
          ),
          CustomPaint(
            painter: AnimatedPaintballPainter(animation: _loopAnimation, color: Theme.of(context).colorScheme.secondary),
            size: Size(70, 70),
          ),
        ],
      ),
    );
  }
}