import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/components/tesarte_navigation_bar/tesarte_navigation_bar.dart';
import 'package:tesArte/common/layouts/skeleton_layout.dart';
import 'package:flutter/material.dart';

class BasicLayout extends StatefulWidget {
  final String? titleView;
  final Widget body;
  final bool? showSideBar;
  final bool canPop;

  /// [VoidCallback] that will be called when the back button is pressed.
  final VoidCallback? onBackButtonPressed;

  const BasicLayout({
    super.key,
    this.titleView,
    required this.body,
    this.showSideBar = true,
    this.canPop = false,
    this.onBackButtonPressed
  });

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

  TesArteIconButton _getBackButton() {
    return TesArteIconButton(
      icon: Icon(Icons.arrow_back),
      tooltipText: "Volver", // TODO: lang
      onPressed: () => widget.onBackButtonPressed != null ? widget.onBackButtonPressed!() : Navigator.pop(context),
    );
  }

  Text _getTitleView() {
    return Text(widget.titleView!,
      textAlign: TextAlign.center,
      style: TextTheme.of(context).displayMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary
      )
    );
  }

  @override
  SkeletonLayout build(BuildContext context) {
    return SkeletonLayout(
      content: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.showSideBar!) tesArteNavigationBar,
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: widget.titleView == null ? widget.body : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (widget.canPop) Align(alignment: Alignment.topLeft, child: _getBackButton()),
                  Container(margin: const EdgeInsets.only(bottom: 15), child: _getTitleView()),
                  Expanded(child: widget.body)
                ],
              )
            )
          ),
        ],
      )
    );
  }
}
