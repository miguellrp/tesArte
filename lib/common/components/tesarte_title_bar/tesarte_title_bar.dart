import 'package:flutter/material.dart';
import 'package:tesArte/common/components/tesarte_title_bar/tesarte_title_bar_button.dart';
import 'package:window_manager/window_manager.dart';


class TesArteTitleBar extends StatelessWidget {
  TesArteTitleBar({super.key});

  final Container titleAppBar = Container(
    margin: const EdgeInsets.only(left: 8),
    child: Text("tesArte", style: TextStyle(fontWeight: FontWeight.bold)),
  );

  void _doMaximizeAction() {
    windowManager.isMaximized().then((isMaximized) {
      if (isMaximized) {
        windowManager.unmaximize();
      } else {
        windowManager.maximize();
      }
    });
  }

  final Row tesArteTitleBarButtons = Row(
    children: [
      TesArteTitleBarButton(buttonType: TesArteTitleBarButtonType.minimize),
      TesArteTitleBarButton(buttonType: TesArteTitleBarButtonType.maximize),
      TesArteTitleBarButton(buttonType: TesArteTitleBarButtonType.close)
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => windowManager.startDragging(),
      onDoubleTap: () => _doMaximizeAction(),
      child: Container(
        height: 30,
        color: Theme.of(context).colorScheme.surfaceTint.withAlpha(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            titleAppBar,
            tesArteTitleBarButtons
          ],
        ),
      ),
    );
  }
}