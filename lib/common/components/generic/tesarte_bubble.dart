import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';

class TesArteBubble extends StatelessWidget {
  final String bubbleText;
  final Widget? bubbleLeading;
  final VoidCallback? onRemove;

  const TesArteBubble({super.key, required this.bubbleText, this.bubbleLeading, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(150),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          if (bubbleLeading != null) bubbleLeading!,
          Text(bubbleText, style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 13)),
          if (onRemove != null) TesArteIconButton(
            icon: Icon(Icons.close, size: 16),
            withSquareShape: true,
            onPressed: onRemove,
            tooltipText: "Eliminar autoría",
          )
        ],
      ),
    );
  }
}
