import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_tooltip/tesarte_tooltip.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteIconButton extends StatefulWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final String? tooltipText;

  final Color? color;
  final double padding;
  final bool withSquareShape;

  const TesArteIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltipText,

    this.color,
    this.padding = 4,
    this.withSquareShape = false
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
  TesArteTooltip build(BuildContext context) {
    return TesArteTooltip(
      message: widget.tooltipText,
      child: IconButton(
        constraints: BoxConstraints(),
        focusNode: _focusButtonNode,
        padding: EdgeInsets.all(widget.padding),
        icon: widget.icon,
        color: widget.color??Theme.of(context).colorScheme.secondary,
        onPressed: widget.onPressed,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.withSquareShape ? 10 : 30),
            side: _focusButtonNode.hasFocus ? BorderSide(color: widget.color??Theme.of(context).colorScheme.secondary) : BorderSide.none
          ))
        ),
      ),
    );
  }
}
