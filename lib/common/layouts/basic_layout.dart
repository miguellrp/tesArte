import 'package:tesArte/common/layouts/skeleton_layout.dart';
import 'package:flutter/material.dart';

class BasicLayout extends StatefulWidget {
  final Widget body;
  const BasicLayout({super.key, required this.body});

  @override
  State<BasicLayout> createState() => _BasicLayoutState();
}

class _BasicLayoutState extends State<BasicLayout> {
  @override
  SkeletonLayout build(BuildContext context) {
    return SkeletonLayout(content: widget.body);
  }
}
