import 'package:flutter/material.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/components/generic/tesarte_text_button.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

enum TesArteDialogType {
  error,
  warning,
  confirm,
  info,
  custom
}

class TesArteDialog {
  static Future<bool?> show(BuildContext context, {
    required TesArteDialogType dialogType,
    required String titleDialog,
    String? subtitleDialog,
    String? coloredText,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(titleDialog, style: TextStyle(color: _getDialogColor(dialogType)),)),
          actions: _getActionButtons(dialogType),
          icon: _getDialogIcon(dialogType),
          iconColor: _getDialogColor(dialogType),
          shape: _getShapeDialog(dialogType),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              if (subtitleDialog.isNotEmptyAndNotNull) Text(subtitleDialog!),
              if (coloredText.isNotEmptyAndNotNull) Text(coloredText!,
                style: TextTheme.of(context).labelLarge!.copyWith(color: _getDialogColor(dialogType).withAlpha(130))
              )
            ],
          ),
        );
      },
    );
  }

  /* --- PRIVATE METHODS --- */
  static List<Widget> _getActionButtons(dialogType) {
    return [
      TesArteTextButton(
        text: "Cancelar", // TODO: lang
        foregroundColor: Theme.of(navigatorKey.currentContext!).colorScheme.tertiary,
        onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(false),
      ),
      TesArteTextButton(
        text: "Confirmar", // TODO: lang
        foregroundColor: _getDialogColor(dialogType),
        onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(true),
      ),
    ];
  }

  static Color _getDialogColor(TesArteDialogType dialogType) {
    Color dialogColor;

    switch (dialogType) {
      case TesArteDialogType.error: dialogColor = Colors.redAccent; break;
      case TesArteDialogType.warning: dialogColor = Colors.orangeAccent; break;
      case TesArteDialogType.confirm: dialogColor = Colors.greenAccent; break;
      case TesArteDialogType.info: dialogColor = Colors.blueAccent; break;
      case TesArteDialogType.custom: dialogColor = Theme.of(navigatorKey.currentContext!).colorScheme.primary; break;
    }

    return dialogColor;
  }

  static Icon _getDialogIcon(TesArteDialogType dialogType) {
    Icon dialogIcon;

    switch (dialogType) {
      case TesArteDialogType.error: dialogIcon = Icon(Icons.error_rounded); break;
      case TesArteDialogType.warning: dialogIcon = Icon(Icons.warning_rounded); break;
      case TesArteDialogType.confirm: dialogIcon = Icon(Icons.check_rounded); break;
      case TesArteDialogType.info: dialogIcon = Icon(Icons.info_rounded); break;
      case TesArteDialogType.custom: dialogIcon = Icon(Icons.info_rounded); break;
    }

    return dialogIcon;
  }

  static RoundedRectangleBorder _getShapeDialog(TesArteDialogType dialogType) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        color: _getDialogColor(dialogType),
        width: 1.5
      )
    );
  }
}