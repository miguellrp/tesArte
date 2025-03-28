// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get accountSuccessfullyCreated => 'Cuenta creada correctamente';

  @override
  String get emptyNameWarning => 'El nombre no puede quedar vacío';

  @override
  String get errorOnCreatingAccount => 'Ha ocurrido un error al intentar crear tu cuenta';

  @override
  String get enterNameToIdentifyYourself => 'Escribe un nombre con el que identificarte:';

  @override
  String get isThisYourFirstTimeHere => '¿Es tu primera vez por aquí?';

  @override
  String get pushOn => 'Continuar';

  @override
  String get home => 'Inicio';

  @override
  String get myBooks => 'Mis libros';

  @override
  String get usernameAlreadyInUse => 'El nombre de usuario ya está en uso';

  @override
  String get yourCulturalLibrary => 'Tu librería cultural';
}
