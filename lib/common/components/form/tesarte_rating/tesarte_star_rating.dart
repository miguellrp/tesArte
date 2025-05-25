import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TesArteStarRating extends StatefulWidget {
  // booleans to SAVE status of star
  bool isHalfStar;
  bool isFullStar;

  // booleans to CHANGE (only visual) status of star
  bool isHoverHalfStar;
  bool isHoverFullStar;

  bool isHoveringGroup;
  VoidCallback? onHover;
  VoidCallback? onTap;

  bool readOnly;

  TesArteStarRating({super.key,
    this.isHalfStar = false,
    this.isFullStar = false,

    this.isHoverHalfStar = false,
    this.isHoverFullStar = false,

    this.isHoveringGroup = false,

    this.onHover,
    this.onTap,

    this.readOnly = true
  });

  @override
  State<TesArteStarRating> createState() => _TesArteStarRatingState();
}

class _TesArteStarRatingState extends State<TesArteStarRating> {
  void doHoverAction(PointerHoverEvent event) {
    setState(() {
      if (event.localPosition.dx >= 16 && event.localPosition.dx <= 26.5) {
        widget.isHoverHalfStar = false;
        widget.isHoverFullStar = true;
      } else if (event.localPosition.dx <= 16) {
        widget.isHoverHalfStar = true;
        widget.isHoverFullStar = false;
      }
    });

    if (widget.onHover != null) widget.onHover!();
  }

  void doExitAction() {
    setState(() {
      widget.isHoverHalfStar = false;
      widget.isHoverFullStar = false;
    });
  }

  void doTapAction() {
    setState(() {
      widget.isHalfStar = widget.isHoverHalfStar;
      widget.isFullStar = widget.isHoverFullStar;

      widget.isHoverHalfStar = false;
      widget.isHoverFullStar = false;
    });

    if (widget.onTap != null) widget.onTap!();
  }

  List<double> _getGradientStops() {
    if (widget.isHoverFullStar || (widget.isFullStar && !widget.isHoveringGroup)) {
      return [1, 1];
    } else if (widget.isHoverHalfStar || (widget.isHalfStar && !widget.isHoveringGroup)) {
      return [0.49, 0.5];
    } else {
      return [0, 0];
    }
  }

  GestureDetector _getStarRatingInteractive() {
    return GestureDetector(
      onTap: () => doTapAction(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) => doHoverAction(event),
        onExit: (_) => doExitAction(),
        child: Container(
          width: 28,
          height: 28,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              colors: [
                if (widget.isHoverHalfStar || widget.isHoverFullStar) Theme.of(context).colorScheme.primary
                else Theme.of(context).colorScheme.secondary,

                Theme.of(context).colorScheme.secondary.withAlpha(150)
              ],
              stops: _getGradientStops(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shape: StarBorder(pointRounding: 0.4)
          ),
        ),
      )
    );
  }

  Container _getStarRatingNoInteractive() {
    return Container(
      width: 12,
      height: 12,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            if (widget.isHoverHalfStar || widget.isHoverFullStar) Theme.of(context).colorScheme.primary
            else Theme.of(context).colorScheme.secondary,

            Theme.of(context).colorScheme.secondary.withAlpha(150)
          ],
          stops: _getGradientStops(),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        shape: StarBorder(pointRounding: 0.4)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.readOnly ? _getStarRatingNoInteractive() : _getStarRatingInteractive();
  }
}