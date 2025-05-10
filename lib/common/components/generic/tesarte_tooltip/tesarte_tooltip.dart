import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_tooltip/tesarte_tooltip_text.dart';

class TesArteTooltip extends StatefulWidget {
  final String? message;
  final Widget child;

  const TesArteTooltip({super.key, required this.message, required this.child});

  @override
  State<TesArteTooltip> createState() => _TesArteTooltipState();
}

class _TesArteTooltipState extends State<TesArteTooltip> {
  final OverlayPortalController _tooltipController = OverlayPortalController();

  late TesArteTooltipText? tesArteTooltipText;
  IconButton? tooltipIconButtonChild;
  late FocusNode? tooltipFocusNode;

  @override
  void initState() {
    if (widget.child is IconButton) tooltipIconButtonChild = widget.child as IconButton;

    if (tooltipIconButtonChild != null) {
      tooltipFocusNode = tooltipIconButtonChild!.focusNode;
      tooltipFocusNode!.addListener(_handleFocusTooltipChange);
    }

    tesArteTooltipText = TesArteTooltipText(text: widget.message);

    super.initState();
  }

  void _handleFocusTooltipChange() {
    if (tooltipFocusNode!.hasFocus) {
      _tooltipController.show();
    } else {
      _tooltipController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _tooltipController.show(),
      onExit: (_) => _tooltipController.hide(),
      child: OverlayPortal(
        controller: _tooltipController,
        overlayChildBuilder: (BuildContext overlayContext) {
          final RenderBox targetRenderBox = context.findRenderObject() as RenderBox;
          final Offset position = targetRenderBox.localToGlobal(Offset.zero);
          final bool isTooltipOffscreenX = (position.dx + tesArteTooltipText!.width) > MediaQuery.of(context).size.width;

          return Positioned(
            top: isTooltipOffscreenX ? position.dy + targetRenderBox.size.height + 5 : position.dy + (targetRenderBox.size.height / 2) - (tesArteTooltipText!.height / 2),
            left: isTooltipOffscreenX ? position.dx + (targetRenderBox.size.width / 2) - (tesArteTooltipText!.width / 2) : position.dx + (targetRenderBox.size.width + 10),
            child: tesArteTooltipText ?? SizedBox.shrink(),
          );
        },
        child: widget.child,
      ),
    );
  }
}