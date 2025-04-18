import 'package:flutter/material.dart';

class TesArteIconButton extends StatefulWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final String? tooltipText;

  final Color? color;

  const TesArteIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltipText,

    this.color
  });

  @override
  State<TesArteIconButton> createState() => _TesArteIconButtonState();
}

class _TesArteIconButtonState extends State<TesArteIconButton> {
  final FocusNode _focusButtonNode = FocusNode();
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();


  @override
  void initState() {
    _focusButtonNode.addListener(() => setState(() {
      if (_focusButtonNode.hasFocus) {
        _tooltipKey.currentState?.ensureTooltipVisible();
      } else {
        // TODO: find a way to hide the tooltip when the button is unfocused
      }
    }));
    super.initState();
  }

  @override
  void dispose() {
    _focusButtonNode.dispose();
    super.dispose();
  }

  @override
  Tooltip build(BuildContext context) {
    return Tooltip(
      key: _tooltipKey,
      message: widget.tooltipText,
      triggerMode: TooltipTriggerMode.manual,
      child: IconButton(
        focusNode: _focusButtonNode,
        padding: EdgeInsets.zero,
        icon: widget.icon,
        color: widget.color??Theme.of(context).colorScheme.secondary,
        onPressed: widget.onPressed,
        style: _focusButtonNode.hasFocus ? ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: widget.color??Theme.of(context).colorScheme.secondary)
          ))
        ) : null,
      ),
    );/*;*/
  }
}
