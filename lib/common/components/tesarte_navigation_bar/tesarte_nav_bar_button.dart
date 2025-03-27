import 'package:flutter/material.dart';

class TesArteNavBarButton extends StatelessWidget {
  final IconData destinationIcon;
  final String destinationTitle;
  final VoidCallback? destinationOnTap;

  final bool selected;
  final bool navBarExtended;

  const TesArteNavBarButton({
    super.key,
    required this.destinationIcon,
    required this.destinationTitle,
    this.destinationOnTap,

    this.selected = false,
    this.navBarExtended = true
  });

  RoundedRectangleBorder _getButtonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
  }

  Icon _getDestinationIcon() {
    return Icon(destinationIcon, color: selected ? Colors.white : Colors.black,);
  }

  @override
  Widget build(BuildContext context) {
    return navBarExtended ? ListTile(
      contentPadding: const EdgeInsets.only(left: 10),
      leading: _getDestinationIcon(),
      title: Text(destinationTitle, style: TextTheme.of(context).bodyMedium, maxLines: 1),
      shape: _getButtonShape(),
      onTap: destinationOnTap,
    ) : IconButton(
      tooltip: destinationTitle,
      icon: _getDestinationIcon(),
      style: ButtonStyle(shape: WidgetStatePropertyAll(_getButtonShape())),
      onPressed: destinationOnTap,
    );
  }
}