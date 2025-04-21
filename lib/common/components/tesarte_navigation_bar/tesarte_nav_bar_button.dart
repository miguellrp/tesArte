import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';

class TesArteNavBarButton extends StatelessWidget {
  final IconData destinationIcon;
  final String destinationTitle;
  final VoidCallback destinationOnTap;

  final bool selected;
  final bool navBarExtended;

  const TesArteNavBarButton({
    super.key,
    required this.destinationIcon,
    required this.destinationTitle,
    required this.destinationOnTap,

    this.selected = false,
    this.navBarExtended = true
  });

  RoundedRectangleBorder _getButtonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
  }

  Icon _getDestinationIcon(BuildContext context) {
    return Icon(destinationIcon,
      color: selected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurface
    );
  }

  @override
  Widget build(BuildContext context) {
    return navBarExtended ? ListTile(
      contentPadding: const EdgeInsets.only(left: 10),
      leading: _getDestinationIcon(context),
      title: Text(destinationTitle,
        maxLines: 1,
        style: TextTheme.of(context).bodyMedium!.copyWith(
        color: selected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurface
        )
      ),
      shape: _getButtonShape(),
      onTap: destinationOnTap,
    ) : TesArteIconButton(
      tooltipText: destinationTitle,
      icon: _getDestinationIcon(context),
      onPressed: destinationOnTap,
      padding: 8,
      withSquareShape: true
    );
  }
}