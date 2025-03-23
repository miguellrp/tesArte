import 'package:tesArte/views/home_view/home_view.dart';
import 'package:tesArte/views/welcome_view/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TesArteRouter {
  static final GoRouter config = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomeView();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeView();
            },
          ),
        ],
      ),
    ],
  );
}