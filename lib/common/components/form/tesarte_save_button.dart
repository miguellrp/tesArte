import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_text_icon_button.dart';

class TesArteSaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final bool formHasChanges;

  const TesArteSaveButton({super.key, required this.onPressed, this.enabled = true, this.formHasChanges = false});

  @override
  TesArteTextIconButton build(BuildContext context) {
    return TesArteTextIconButton(
      text: "Gardar cambios", // TODO: lang
      subText: formHasChanges ? "Con cambios sen gardar" : null, // TODO: lang
      icon: enabled ? Icons.save : Icons.save_outlined,
      enabled: enabled,
      onPressed: enabled ? () => onPressed() : null,
    );
  }
}
