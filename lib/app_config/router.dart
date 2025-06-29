import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/models/book/book_model.dart';
import 'package:tesArte/views/book_authors_view/book_authors_view.dart';
import 'package:tesArte/book/views/book_edit_view.dart';
import 'package:tesArte/book/views/your_books_view.dart';
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
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(HomeView())
      ),

      GoRoute(
        path: '/your_books',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(YourBooksView())
      ),

      GoRoute(
        path: '/book_edit',
        pageBuilder: (context, state) => _getFadeTransitionViewBuilder(BookEditView(
          controller: state.extra != null ? state.extra as BookController : BookController(model: BookModel())
        ))
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