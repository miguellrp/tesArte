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
  Widget build(BuildContext context) {
    return BasicLayout(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text("HOME PAGE")
        ]
      )
    );
  }
}
