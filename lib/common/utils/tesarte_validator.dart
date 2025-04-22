import 'package:flutter/material.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/l10n/generated/app_localizations.dart';

enum TesArteValidatorType {
  /// Any type of string
  name,
  /// Only integer numbers (not floating point allowed)
  integerNumber,
  /// All kind of numeric values (including floating point)
  numeric
}

abstract class TesArteValidator {
  static String? doValidation({required TesArteValidatorType type, required String? value, bool allowEmpty = true}) {
    switch(type) {
      case TesArteValidatorType.name:
        return _validateName(value, allowEmpty);
      case TesArteValidatorType.integerNumber:
        return _validateIntegerNumber(value, allowEmpty);
      case TesArteValidatorType.numeric:
        return _validateIntegerNumber(value, allowEmpty);
    }
  }

  /* --- PRIVATE VALIDATORS FUNCTIONS --- */
  static String? _validateName(String? name, bool allowEmpty) {
    return name.isEmptyOrNull && allowEmpty ? AppLocalizations.of(navigatorKey.currentContext!)!.emptyNameWarning : null;
  }

  static String? _validateIntegerNumber(String? number, bool allowEmpty) {
    String? errorValidationMessage;

    if (!allowEmpty && number.isEmptyOrNull) {
      errorValidationMessage = "O campo non pode quedar baleiro"; // TODO: lang
    } else if (!allowEmpty && !UtilText.isIntegerNumber(number)) {
      errorValidationMessage = "O campo non ten un formato válido"; // TODO: lang
    }

    return errorValidationMessage;
  }
}