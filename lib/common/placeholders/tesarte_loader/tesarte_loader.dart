import 'package:tesArte/common/placeholders/tesarte_loader/animated_paintball_painter.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_mask_painter.dart';
import 'package:flutter/material.dart';

enum LoaderSize {
  small,
  large,
}

class TesArteLoader extends StatefulWidget {
  final LoaderSize loaderSize;
  const TesArteLoader({super.key, this.loaderSize = LoaderSize.large});

  @override
  TesArteLoaderState createState() => TesArteLoaderState();
}

class TesArteLoaderState extends State<TesArteLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _loopAnimation;
  late final Map<String, Size> loaderSizes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();

    _loopAnimation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    loaderSizes = _getLoaderSize(widget.loaderSize);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, Size> _getLoaderSize(LoaderSize loaderSize) {
    Map<String, Size> resultSize;

    switch (loaderSize) {
      case LoaderSize.small:
        resultSize = {
          "mask": Size(25, 25),
          "paintball": Size(50, 50)
        };
        break;
      default:
        resultSize = {
          "mask": Size(45, 45),
          "paintball": Size(70, 70)
        };
    }

    return resultSize;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: TesArteMaskPainter(color: Theme.of(context).colorScheme.primary),
            size: loaderSizes["mask"]!,
          ),
          CustomPaint(
            painter: AnimatedPaintballPainter(animation: _loopAnimation, color: Theme.of(context).colorScheme.secondary),
            size: loaderSizes["paintball"]!,
          )
        ],
      ),
    );
  }
}