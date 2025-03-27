import 'package:tesArte/common/components/tesarte_navigation_bar/tesarte_navigation_bar.dart';
import 'package:tesArte/common/layouts/skeleton_layout.dart';
import 'package:flutter/material.dart';

class BasicLayout extends StatefulWidget {
  final Widget body;
  final bool? showSideBar;

  const BasicLayout({super.key, required this.body, this.showSideBar = true});

  @override
  State<BasicLayout> createState() => _BasicLayoutState();
}

class _BasicLayoutState extends State<BasicLayout> {
  late TesArteNavigationBar tesArteNavigationBar;

  @override
  void initState() {
    tesArteNavigationBar = TesArteNavigationBar();
    super.initState();
  }
  @override
  SkeletonLayout build(BuildContext context) {
    return SkeletonLayout(content: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        tesArteNavigationBar,
        Expanded(child: widget.body),
      ],
    ));
  }
}
