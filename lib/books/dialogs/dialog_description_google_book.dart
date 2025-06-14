import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class DialogDescriptionGoogleBook {
  static show(BuildContext context, {
    required String titleBook,
    required String descriptionBook,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: _getShapeDialog(context),
        child: Container(
          constraints: BoxConstraints(maxWidth: 1440, maxHeight: 860),
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Align(alignment: Alignment.topRight, child: _getCloseButtonDialog(context)),
              _getTitleDialog(context, titleBook),
              Flexible(child: SingleChildScrollView(child: SelectableText(descriptionBook, textAlign: TextAlign.center))),
            ],
          ),
        ),
      )
    );
  }


  /* --- PRIVATE METHODS --- */
  static RoundedRectangleBorder _getShapeDialog(BuildContext context) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.lighten(),
        width: 2
      )
    );
  }

  static Text _getTitleDialog(BuildContext context, String titleBook) {
    return Text(titleBook,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextTheme.of(context).titleLarge!.copyWith(
        color: Theme.of(context).colorScheme.secondary,
        decoration: TextDecoration.underline,
        decorationColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  static TesArteIconButton _getCloseButtonDialog(BuildContext context) {
    return TesArteIconButton(
      icon: Icon(Icons.close),
      tooltipText: "Pechar descrición", // TODO: lang
      onPressed: () => Navigator.pop(context)
    );
  }
}