import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesArte/common/components/tesarte_navigation_bar/tesarte_nav_bar_button.dart';
import 'package:tesArte/common/utils/util_viewport.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';
import 'package:tesArte/views/books_view/books_view.dart';
import 'package:tesArte/views/home_view/home_view.dart';

class TesArteNavigationBar extends StatefulWidget {
  const TesArteNavigationBar({
    super.key,
  });

  @override
  State<TesArteNavigationBar> createState() => _TesArteNavigationBarState();
}

class _TesArteNavigationBarState extends State<TesArteNavigationBar> {
  bool navBarExtended = true;

  @override
  void didChangeDependencies() {
    navBarExtended = !UtilViewport.isNarrowScreen(context);
    super.didChangeDependencies();
  }

  List<TesArteNavBarButton> _getNavBarButtons() {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    return [
      TesArteNavBarButton(
        destinationIcon: Icons.home_filled,
        destinationTitle: "Inicio", // TODO: lang
        selected: currentRoute == HomeView.route,
        navBarExtended: navBarExtended,
        destinationOnTap: () => context.go(HomeView.route)
      ),
      TesArteNavBarButton(
        destinationIcon: Icons.book,
        destinationTitle: "Mis libros", // TODO: lang
        selected: currentRoute == BooksView.route,
        navBarExtended: navBarExtended,
        destinationOnTap: () => context.go(BooksView.route)
      )
    ];
  }

  @override
  AnimatedContainer build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      constraints: BoxConstraints(maxWidth: navBarExtended ? 250 : 70),
      color: Theme.of(context).colorScheme.surfaceTint.withAlpha(150),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        spacing: 10,
        children: [
          if (navBarExtended) Text(TesArteSession.instance.getActiveUser()!.userName!),
          const Placeholder(child: SizedBox(height: 40, width: 80)),
          Divider(),
          ..._getNavBarButtons()
        ],
      ),
    );
  }
}
