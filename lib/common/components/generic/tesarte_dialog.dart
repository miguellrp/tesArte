import 'package:flutter/material.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/components/generic/tesarte_text_button.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class TesArteDialog {
  static Future<bool?> show(BuildContext context, {
    required String titleDialog,
    String? subtitleDialog,
    String? coloredText,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(titleDialog)),
          actions: _getActionButtons(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (subtitleDialog.isNotEmptyAndNotNull) Text(subtitleDialog!),
              if (coloredText.isNotEmptyAndNotNull) Text(coloredText!, style: TextStyle(color: Theme.of(context).colorScheme.primary))
            ],
          ),
        );
      },
    );
  }

  /* --- PRIVATE METHODS --- */
  static List<Widget> _getActionButtons() {
    return [
      TesArteTextButton(
        text: "Cancelar", // TODO: lang
        onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(false),
      ),
      TesArteTextButton(
        text: "Aceptar", // TODO: lang
        onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(true),
      ),
    ];
  }
}