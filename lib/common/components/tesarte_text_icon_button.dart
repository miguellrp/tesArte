import 'package:flutter/material.dart';

class TesArteTextIconButton extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final VoidCallback onPressed;

  final Color? backgroundColor;
  final Color? foregroundColor;

  const TesArteTextIconButton({super.key,
    required this.text,
    this.iconData,
    required this.onPressed,

    this.backgroundColor,
    this.foregroundColor
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(text),
      icon: iconData != null ? Icon(iconData) : null,
      onPressed: () => onPressed(),
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
        elevation: WidgetStatePropertyAll(8),
        shadowColor: WidgetStatePropertyAll(Colors.black),
        backgroundColor: backgroundColor != null ? WidgetStatePropertyAll(backgroundColor) : WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
        foregroundColor: foregroundColor != null ? WidgetStatePropertyAll(foregroundColor) : WidgetStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold))
      ),
    );
  }
}
