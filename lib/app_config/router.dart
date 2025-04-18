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
        builder: (BuildContext context, GoRouterState state) {
          return WelcomeView();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) => HomeView(),
      ),
      GoRoute(
        path: '/books',
        builder: (BuildContext context, GoRouterState state) => BooksView(),
      ),
    ],
  );
}