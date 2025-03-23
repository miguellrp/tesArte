import 'package:tesArte/common/components/tesarte_loader/animated_paintball_painter.dart';
import 'package:tesArte/common/components/tesarte_loader/theater_mask_painter.dart';
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
  late final Animation<double> _animation;
  late final CurvedAnimation _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(opacity: _fadeAnimation, child: child),
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: TheaterMaskPainter(color: Theme.of(context).colorScheme.primary),
              size: Size(45, 45),
            ),
            CustomPaint(
              painter: AnimatedPaintballPainter(animation: _animation, color: Theme.of(context).colorScheme.secondary),
              size: Size(70, 70),
            ),
          ],
        ),
      ),
    );
  }
}