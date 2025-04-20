import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_text_icon_button.dart';

class TesArteSaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enable;

  const TesArteSaveButton({super.key, required this.onPressed, this.enable = true});

  @override
  TesArteTextIconButton build(BuildContext context) {
    return TesArteTextIconButton(
      text: "Guardar cambios", // TODO: lang
      icon: enable ? Icons.save : Icons.save_outlined,
      onPressed: enable ? () => onPressed() : null,
    );
  }
}
