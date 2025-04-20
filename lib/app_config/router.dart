import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/books_view/book_edit_view.dart';
import 'package:tesArte/views/books_view/books_view.dart';
import 'package:tesArte/views/home_view/home_view.dart';
import 'package:tesArte/views/welcome_view/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TesArteRouter {
  static final GoRouter config = GoRouter(
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        name: 'welcoming',
        path: '/',
        builder: (BuildContext context, GoRouterState state) => WelcomeView()
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(HomeView()),
      ),
      GoRoute(
        path: '/books',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(BooksView()),
      ),
      GoRoute(
        path: '/book_edit',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(BookEditView(book: state.extra != null ? state.extra as Book : Book()))
      ),
    ],
  );

  static CustomTransitionPage _getFadeTransitionViewBuilder(Widget child, {Object? objectParam}) {
    return CustomTransitionPage(
      child: child,
      arguments: objectParam,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      )
    );
  }
}