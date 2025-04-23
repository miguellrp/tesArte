// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accountSuccessfullyCreated => 'Account successfully created';

  @override
  String get emptyNameWarning => 'Name cannot be empty';

  @override
  String get errorOnCreatingAccount => 'An error occurred while trying to create your account';

  @override
  String get enterNameToIdentifyYourself => 'Enter a name to identify yourself:';

  @override
  String get isThisYourFirstTimeHere => 'Is this your first time here?';

  @override
  String get pushOn => 'Continue';

  @override
  String get home => 'Home';

  @override
  String get yourBooks => 'Your books';

  @override
  String get usernameAlreadyInUse => 'Username is already in use';

  @override
  String get yourCulturalLibrary => 'Your cultural library';
}
