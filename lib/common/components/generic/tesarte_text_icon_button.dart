import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteTextIconButton extends StatefulWidget {
  final String text;
  final String? subText;
  final IconData? icon;
  final VoidCallback? onPressed;

  final bool enabled;

  final Color? backgroundColor;
  final Color? foregroundColor;

  const TesArteTextIconButton({
    super.key,
    required this.text,
    this.subText,
    this.icon,
    this.onPressed,

    this.enabled = true,

    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<TesArteTextIconButton> createState() => _TesArteTextIconButtonState();
}

class _TesArteTextIconButtonState extends State<TesArteTextIconButton> {
  late final FocusNode _focusNode;
  bool _isHovering = false;

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

  void _onHoverAction(bool isHovering) {
    setState(() => _isHovering = isHovering);
  }

  WidgetStatePropertyAll<Color> _getBackgroundColor() {
    WidgetStatePropertyAll<Color> backgroundColor = WidgetStatePropertyAll(widget.backgroundColor ?? Theme.of(context).colorScheme.secondary);

    if (!widget.enabled) {
      backgroundColor = WidgetStatePropertyAll(widget.backgroundColor?.darken(percent: .4) ?? Theme.of(context).colorScheme.secondary.darken(percent: .4));
    }

    return backgroundColor;
  }

  TextStyle _getTextStyle() => Theme.of(context).textTheme.bodyMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSecondary,
  );

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.text, style: _getTextStyle()),
          if (widget.subText.isNotEmptyAndNotNull) Text(widget.subText!, style: _getTextStyle().copyWith(fontSize: 11, fontStyle: FontStyle.italic))
        ],
      ),
      icon: widget.icon != null ? Icon(widget.icon, color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSecondary) : null,
      onPressed: widget.enabled ? widget.onPressed : null,
      focusNode: _focusNode,
      onFocusChange: (bool isFocusing) => _onFocusAction(isFocusing),
      onHover: (bool isHovering) => _onHoverAction(isHovering),
      style: ButtonStyle(
        visualDensity: VisualDensity.comfortable,
        elevation: WidgetStatePropertyAll(widget.enabled ? 8 : 2),
        shadowColor: WidgetStatePropertyAll(Colors.black),
        backgroundColor: _getBackgroundColor(),
        foregroundColor: WidgetStatePropertyAll(widget.foregroundColor ?? Theme.of(context).colorScheme.onSecondary),
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 2.5,
              strokeAlign: (_focusNode.hasFocus || _isHovering) ? 2.5 : 0.5,
              color: Theme.of(context).colorScheme.secondary.darken(percent: widget.enabled ? 0.2 : 0.7),
            ),
          ),
        ),
      ),
    );
  }
}