import 'package:tesArte/common/utils/tesarte_extensions.dart';

enum TesArteValidatorType {
  name,

}

abstract class TesArteValidator {
  static String? doValidation({required TesArteValidatorType type, required String? value}) {
    switch(type) {
      case TesArteValidatorType.name:
        return _validateName(value);
    }
  }

  /* --- PRIVATE VALIDATORS FUNCTIONS --- */
  static String? _validateName(String? name) {
    // TODO: lang
    return name.isEmptyOrNull ? "O nome non pode quedar baleiro" : null; // TODO: lang
  }
}