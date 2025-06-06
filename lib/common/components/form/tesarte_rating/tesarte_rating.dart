import 'package:flutter/material.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_star_rating.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';

class TesArteRating extends StatefulWidget {
  /// [double] value between 0 and 5
  double? rating;
  bool readOnly;
  VoidCallback? onChange;

  TesArteRating({super.key, this.rating = 1.5, this.readOnly = false, this.onChange});

  @override
  State<TesArteRating> createState() => _TesArteRatingState();
}

class _TesArteRatingState extends State<TesArteRating> {
  List<TesArteStarRating> totalStars = [];
  double? hoverRating;

  Row _getRatingStars() {
    totalStars = List.generate(5, (index) =>  TesArteStarRating(
      readOnly: widget.readOnly,
      isHalfStar: widget.rating != null && (widget.rating! > index && widget.rating! < index + 1),
      isFullStar: widget.rating != null && index < widget.rating!.floor(),
      isHoverHalfStar: hoverRating != null && (hoverRating! > index && hoverRating! < index + 1),
      isHoverFullStar: hoverRating != null && index < hoverRating!.floor(),
      isHoveringGroup: hoverRating != null,
      onHover: () => doHoverAction(index),
      onTap: () => doTapAction(index),
    ));

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: totalStars
    );
  }

  void doHoverAction(int indexStar) {
    setState(() {
      hoverRating = indexStar.toDouble();
      hoverRating = hoverRating! + (totalStars[indexStar].isHoverHalfStar ? 0.5 : 1);
    });
  }

  void doTapAction(int indexStar) {
    setState(() {
      widget.rating = (indexStar + 1).toDouble();
      if (totalStars[indexStar].isHalfStar) widget.rating = widget.rating! - 0.5;

      if (widget.onChange != null) widget.onChange!();
    });
  }

  void doExitAction() {
    setState(() => hoverRating = null);
  }

  void doClearRatingAction() {
    setState(() => widget.rating = null);

    if (widget.onChange != null) widget.onChange!();
  }

  Container _getRatingInteractive() {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Visibility(
            visible: widget.rating != null,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: TesArteIconButton(
              icon: Icon(Icons.close, color: Theme.of(context).colorScheme.primary, size: 16),
              onPressed: () => doClearRatingAction(),
            ),
          ),
          MouseRegion(
            onExit: (_) => doExitAction(),
            child: _getRatingStars()
          ),
          SizedBox(width: 22)
        ],
      ),
    );
  }

  Text _getRatingPlaceholder() => Text(
    "Sen valorar", // TODO: lang
    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Theme.of(context).colorScheme.secondary.withAlpha(190),
      fontSize: 10,
      fontStyle: FontStyle.italic
    )
  );

  Container _getRatingNoInteractive() {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withAlpha(100),
          width: 1
        )
      ),
      child: widget.rating != null ? _getRatingStars() : _getRatingPlaceholder()
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.rating == null || widget.rating! >= 0 && widget.rating! <= 5, "Rating must be between 0 and 5 [value = ${widget.rating}]");

    return widget.readOnly ? _getRatingNoInteractive() : _getRatingInteractive();
  }
}
