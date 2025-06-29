import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteBubble extends StatelessWidget {
  final String bubbleText;
  final Widget? bubbleLeading;
  final VoidCallback? onPressed;
  final VoidCallback? onRemove;

  const TesArteBubble({super.key, required this.bubbleText, this.bubbleLeading, this.onPressed, this.onRemove});

  @override
  InputChip build(BuildContext context) {
    return InputChip(
      padding: const EdgeInsets.all(4),
      avatar: bubbleLeading,
      color: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface.lighten(percent: .1)),
      label: Text(bubbleText, style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 14)),
      onPressed: onPressed,
      onDeleted: onRemove
    );
  }
}
