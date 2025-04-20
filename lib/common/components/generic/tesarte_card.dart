import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteCard extends StatelessWidget {
  final Color? cardColor;
  final List<Widget> widgets;

  final double spacing;


  const TesArteCard({
    super.key,
    this.cardColor,
    required this.widgets,

    this.spacing = 3
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 650),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        color: cardColor ?? Theme.of(context).colorScheme.onSurface.darken(percent: .2),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing,
            children: widgets,
          ),
        ),
      ),
    );
  }
}