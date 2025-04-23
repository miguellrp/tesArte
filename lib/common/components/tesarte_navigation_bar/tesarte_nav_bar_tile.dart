import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/components/tesarte_navigation_bar/tesarte_navigation_bar.dart';

// TODO: 🛠️ refactor -> split DestinationTile to ExpansionTile and SingleTile 🛠️
class TesArteNavBarDestinationTile {
  final IconData icon;
  final String title;
  final String? route;
  final bool selected;

  final VoidCallback? onTap;

  TesArteNavBarDestinationTile({
    required this.icon,
    required this.title,
    this.route,
    this.selected = false,

    this.onTap
  });
}


class TesArteNavBarTile extends StatelessWidget {
  final TesArteNavBarDestinationTile destinationTile;
  /// [List] of [TesArteNavBarDestinationTile] only used when [isExpansionTile] is true, as sub destination tiles.
  final List<TesArteNavBarDestinationTile>? subDestinationTiles;

  final bool selected;
  final bool navBarExtended;
  final bool isExpansionTile;

  const TesArteNavBarTile({
    super.key,
    required this.destinationTile,
    this.subDestinationTiles,

    this.selected = false,
    this.navBarExtended = true,
    this.isExpansionTile = false
  });

  RoundedRectangleBorder _getButtonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
  }

  Icon _getDestinationTileIcon({required IconData iconData, required bool isExpansionTile, required bool selected}) {
    return Icon(iconData, color: _getDestinationTileColor(selected: selected, isExpansionTile: isExpansionTile));
  }

  Text _getDestinationTileText({required String title, required bool selected, required bool isExpansionTile}) {
    return Text(title,
      maxLines: 1,
      overflow: TextOverflow.fade,
      style: TextTheme.of(navigatorKey.currentContext!).labelLarge!.copyWith(
        color: _getDestinationTileColor(selected: selected, isExpansionTile: isExpansionTile),
        fontWeight: selected ? FontWeight.bold : FontWeight.normal
      )
    );
  }

  Color _getDestinationTileColor({required bool selected, required bool isExpansionTile}) {
    return selected
      ? (isExpansionTile ? Theme.of(navigatorKey.currentContext!).colorScheme.primary : Theme.of(navigatorKey.currentContext!).colorScheme.secondary)
      : Theme.of(navigatorKey.currentContext!).colorScheme.onSurface;
  }

  List<Widget> _getChildrenTiles() {
    return subDestinationTiles!.map((subDestinationTile) => SizedBox(
      width: TesArteNavigationBar.navigationBarExtendedWidth,
      child: ListTile(
        leading: _getDestinationTileIcon(iconData: subDestinationTile.icon, isExpansionTile: false, selected: subDestinationTile.selected),
        title: _getDestinationTileText(title: subDestinationTile.title, isExpansionTile: false, selected: subDestinationTile.selected),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        shape: _getButtonShape(),
        onTap: subDestinationTile.onTap,
      ),
    ))
    .toList();
  }

  List<PopupMenuEntry<String>> _getDropdownItems() {
    return subDestinationTiles!.map((subDestinationTile) => PopupMenuItem(
      value: subDestinationTile.route,
      child: Row(
        spacing: 10,
        children: [
          Icon(subDestinationTile.icon, color: _getDestinationTileColor(selected: subDestinationTile.selected, isExpansionTile: false)),
          _getDestinationTileText(title: subDestinationTile.title, selected: subDestinationTile.selected, isExpansionTile: false)
        ]
      )
    )).toList();
  }

  Widget _getNavBarExpansionTile(BuildContext context) {
    late Widget navBarTile;

    if (navBarExtended) {
      navBarTile = SizedBox(
        width: TesArteNavigationBar.navigationBarExtendedWidth,
        child: ExpansionTile(
          leading: _getDestinationTileIcon(iconData: destinationTile.icon, isExpansionTile: true, selected: destinationTile.selected),
          title: _getDestinationTileText(title: destinationTile.title, isExpansionTile: true, selected: destinationTile.selected),
          initiallyExpanded: destinationTile.selected,
          children: _getChildrenTiles()
        )
      );
    } else {
      navBarTile = PopupMenuButton<String>(
        tooltip: destinationTile.title,
        onSelected: (selectedRoute) => context.go(selectedRoute),
        splashRadius: 2,
        icon: _getDestinationTileIcon(iconData: destinationTile.icon, isExpansionTile: true, selected: destinationTile.selected),
        shape: RoundedRectangleBorder(),
        itemBuilder: (_) => _getDropdownItems()
      );
    }

    return navBarTile;
  }

  Widget _getNavBarDestinationTile(BuildContext context) {
    late Widget navBarDestinationTile;

    if (navBarExtended) {
      navBarDestinationTile = SizedBox(
        width: TesArteNavigationBar.navigationBarExtendedWidth,
        child: ListTile(
          leading: _getDestinationTileIcon(iconData: destinationTile.icon, isExpansionTile: false, selected: destinationTile.selected),
          title: _getDestinationTileText(title: destinationTile.title, isExpansionTile: false, selected: destinationTile.selected),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          shape: _getButtonShape(),
          onTap: destinationTile.onTap,
        ),
      );
    } else {
      navBarDestinationTile = TesArteIconButton(
        tooltipText: destinationTile.title,
        icon: _getDestinationTileIcon(iconData: destinationTile.icon, isExpansionTile: false, selected: destinationTile.selected),
        onPressed: destinationTile.onTap,
        padding: 8,
        withSquareShape: true
      );
    }

    return navBarDestinationTile;
  }

  @override
  Widget build(BuildContext context) {
    return isExpansionTile ? _getNavBarExpansionTile(context) : _getNavBarDestinationTile(context);
  }
}