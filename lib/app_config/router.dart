import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/book_authors_view/book_authors_view.dart';
import 'package:tesArte/views/your_books_view/book_edit_view.dart';
import 'package:tesArte/views/your_books_view/your_books_view.dart';
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
        path: '/your_books',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(YourBooksView()),
      ),

      GoRoute(
        path: '/book_edit',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(BookEditView(book: state.extra != null ? state.extra as Book : Book()))
      ),

      GoRoute(
        path: '/book_authors',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(BookAuthorsView()),
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