import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  static const String route = "/home";

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  BasicLayout build(BuildContext context) {
    return BasicLayout(
      titleView: "A túa actividade recente", // TODO: lang
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text("TODO: recent activity"),
        ]
      )
    );
  }
}
