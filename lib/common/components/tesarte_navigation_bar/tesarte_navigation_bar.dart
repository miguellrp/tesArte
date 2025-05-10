import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesArte/common/components/tesarte_navigation_bar/tesarte_nav_bar_tile.dart';
import 'package:tesArte/common/utils/util_viewport.dart';
import 'package:tesArte/l10n/generated/app_localizations.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';
import 'package:tesArte/views/your_books_view/your_books_view.dart';
import 'package:tesArte/views/home_view/home_view.dart';

class TesArteNavigationBar extends StatefulWidget {
  static final double navigationBarExtendedWidth = 250;

  const TesArteNavigationBar({
    super.key,
  });

  @override
  State<TesArteNavigationBar> createState() => _TesArteNavigationBarState();
}

class _TesArteNavigationBarState extends State<TesArteNavigationBar> {
  bool navBarExtended = true;
  String? currentRoute;

  @override
  void didChangeDependencies() {
    navBarExtended = !UtilViewport.isNarrowScreen(context);
    currentRoute = GoRouterState.of(context).uri.toString();

    super.didChangeDependencies();
  }

  Column _getNavBarTiles() {
    return Column(
      spacing: 5,
      children: [
        TesArteNavBarTile(
          navBarExtended: navBarExtended,
          destinationTile: TesArteNavBarDestinationTile(
              icon: Icons.home_filled,
              title: AppLocalizations.of(context)!.home,
              route: HomeView.route,
              selected: currentRoute == HomeView.route,
              onTap: () => context.go(HomeView.route)
          )
        ),
        TesArteNavBarTile(
          navBarExtended: navBarExtended,
          destinationTile: TesArteNavBarDestinationTile(
            icon: Icons.book,
            title: AppLocalizations.of(context)!.yourBooks,
            selected: currentRoute == YourBooksView.route,
            onTap: () => context.go(YourBooksView.route)
          )
        )
      ],
    );
  }

  @override
  AnimatedContainer build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      constraints: BoxConstraints(maxWidth: navBarExtended ? TesArteNavigationBar.navigationBarExtendedWidth : 70),
      color: Theme.of(context).colorScheme.surfaceTint.withAlpha(150),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        spacing: 10,
        children: [
          if (navBarExtended) Text(TesArteSession.instance.getActiveUser()!.userName!),
          const Placeholder(child: SizedBox(height: 40, width: 80)),
          Divider(),
          _getNavBarTiles()
        ],
      ),
    );
  }
}