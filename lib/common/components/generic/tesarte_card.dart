import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteCard extends StatelessWidget {
  final Color? cardColor;
  final List<Widget> widgets;
  final Axis direction;

  final double spacing;


  const TesArteCard({
    super.key,
    this.cardColor,
    required this.widgets,
    this.direction = Axis.horizontal,

    this.spacing = 3
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      color: cardColor ?? Theme.of(context).colorScheme.onSurface.darken(percent: .2),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: direction == Axis.horizontal ? Row (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacing,
          children: widgets
        ) : Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: widgets
        ),
      ),
    );
  }
}