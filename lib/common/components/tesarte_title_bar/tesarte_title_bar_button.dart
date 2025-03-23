import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const double titleBarButtonSize = 16;

enum TesArteTitleBarButtonType {
  minimize,
  maximize,
  close
}

class TesArteTitleBarButton extends StatelessWidget {
  final TesArteTitleBarButtonType buttonType;

  const TesArteTitleBarButton({
    super.key,
    required this.buttonType
  });

  IconData _getIcon() {
    IconData icon;

    switch (buttonType) {
      case TesArteTitleBarButtonType.minimize:
        icon = Icons.minimize; break;

      case TesArteTitleBarButtonType.maximize:
        icon = Icons.crop_5_4; break;

      case TesArteTitleBarButtonType.close:
        icon = Icons.close;
    }

    return icon;
  }

  void _doPressedAction() {
    void doMaximizeAction() {
      windowManager.isMaximized().then((isMaximized) {
        if (isMaximized) {
          windowManager.unmaximize();
        } else {
          windowManager.maximize();
        }
      });
    }

    switch (buttonType) {
      case TesArteTitleBarButtonType.minimize:
        windowManager.minimize(); break;

      case TesArteTitleBarButtonType.maximize:
        doMaximizeAction();
        break;

      case TesArteTitleBarButtonType.close:
        windowManager.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_getIcon(), size: titleBarButtonSize),
      onPressed: _doPressedAction,
      mouseCursor: SystemMouseCursors.basic,
      hoverColor: buttonType == TesArteTitleBarButtonType.close ? Colors.redAccent.withAlpha(80) : Colors.white.withAlpha(15),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      style: ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder())),
    );
  }
}