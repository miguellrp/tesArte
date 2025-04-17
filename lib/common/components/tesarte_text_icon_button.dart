import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteTextIconButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  final Color? backgroundColor;
  final Color? foregroundColor;

  const TesArteTextIconButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<TesArteTextIconButton> createState() => _TesArteTextIconButtonState();
}

class _TesArteTextIconButtonState extends State<TesArteTextIconButton> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusAction(bool isFocusing) {
    setState(() {
      if (isFocusing) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(widget.text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      icon: widget.icon != null ? Icon(widget.icon, color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSecondary) : null,
      onPressed: () => widget.onPressed(),
      focusNode: _focusNode,
      onFocusChange: (bool isFocusing) => _onFocusAction(isFocusing),
      onHover: (bool isHovering) => _onFocusAction(isHovering),
      style: ButtonStyle(
        visualDensity: VisualDensity.comfortable,
        elevation: WidgetStatePropertyAll(8),
        shadowColor: WidgetStatePropertyAll(Colors.black),
        backgroundColor: WidgetStatePropertyAll(widget.backgroundColor ?? Theme.of(context).colorScheme.secondary),
        foregroundColor: WidgetStatePropertyAll(widget.foregroundColor ?? Theme.of(context).colorScheme.onSecondary),
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 2.5,
              strokeAlign: _focusNode.hasFocus ? 2.5 : 0.5,
              color: Theme.of(context).colorScheme.secondary.darken(percent: 0.1),
            ),
          ),
        ),
      ),
    );
  }
}