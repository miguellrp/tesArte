import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  static const String route = "/home";

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  Text _getTitleView() {
    return Text("A miña actividade recente", // TODO: lang
      textAlign: TextAlign.center,
      style: TextTheme.of(context).displayMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary
      )
    );
  }

  @override
  BasicLayout build(BuildContext context) {
    return BasicLayout(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          _getTitleView(),
        ]
      )
    );
  }
}
