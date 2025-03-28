import 'package:flutter/material.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/l10n/generated/app_localizations.dart';

enum TesArteValidatorType {
  name,

}

abstract class TesArteValidator {
  static String? doValidation({required TesArteValidatorType type, required String? value, required BuildContext context}) {
    switch(type) {
      case TesArteValidatorType.name:
        return _validateName(value, context);
    }
  }

  /* --- PRIVATE VALIDATORS FUNCTIONS --- */
  static String? _validateName(String? name, BuildContext context) {
    return name.isEmptyOrNull ? AppLocalizations.of(context)!.emptyNameWarning : null;
  }
}