import 'package:flutter/material.dart';

class TesArteTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  final Color? foregroundColor;

  const TesArteTextButton({super.key,
    required this.text,
    required this.onPressed,

    this.foregroundColor
  });

  @override
  State<TesArteTextButton> createState() => _TesArteTextButtonState();
}

class _TesArteTextButtonState extends State<TesArteTextButton> {
  bool _isHover = false;

  void onHover(bool isHover) {
    setState(() => _isHover = isHover);
  }

  Color getOverlayColor() {
    Color overlayColor = widget.foregroundColor?.withAlpha(10) ?? Theme.of(context).colorScheme.primary.withAlpha(10);

    if (_isHover) {
      overlayColor = widget.foregroundColor?.withAlpha(30) ?? Theme.of(context).colorScheme.primary.withAlpha(30);
    }

    return overlayColor;
  }

  Color getForegroundColor() {
    Color foregroundColor = widget.foregroundColor?.withAlpha(160) ?? Theme.of(context).colorScheme.primary.withAlpha(160);

    if (_isHover) {
      foregroundColor = widget.foregroundColor ?? Theme.of(context).colorScheme.primary;
    }

    return foregroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        elevation: WidgetStatePropertyAll(8),
        overlayColor: WidgetStatePropertyAll(getOverlayColor()),
        foregroundColor: WidgetStatePropertyAll(getForegroundColor()),
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold))
      ),
      onHover: (isHover) => onHover(isHover),
      onPressed: () => widget.onPressed(),
      child: Text(widget.text),
    );
  }
}
