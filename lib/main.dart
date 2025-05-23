import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/l10n/generated/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

import 'package:tesArte/app_config/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    minimumSize: Size(350, 400),
    center: true,
    backgroundColor: Colors.red,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  runApp(TesArteApp());
}

class TesArteApp extends StatelessWidget {
  const TesArteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'tesArte',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('gl'), // TODO: getPreferredLocale
      supportedLocales: [
        Locale('gl'),
        Locale('es'),
        Locale('en'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: tesArteTextTheme,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: lightColorScheme.onPrimary,
          selectionColor: lightColorScheme.primary,
          selectionHandleColor: lightColorScheme.onPrimary
        )
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        splashColor: Colors.transparent,
        textTheme: tesArteTextTheme,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: darkColorScheme.tertiary,
          selectionColor: darkColorScheme.secondary.darken(),
          selectionHandleColor: darkColorScheme.secondary.darken()
        ),
      ),
      routerConfig: TesArteRouter.config,
    );
  }
}

// --- 🔠 tesArte TEXT THEME 🔠 ---
// Reference: https://api.flutter.dev/flutter/material/TextTheme-class.html
final TextTheme tesArteTextTheme = TextTheme(
  displayLarge: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 57),
  displayMedium: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 45),
  displaySmall: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 36),
  headlineLarge: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 34),
  headlineMedium: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 32),
  headlineSmall: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 30),
  titleLarge: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 26),
  titleMedium: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 24),
  titleSmall: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 22, height: 1),
  bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16),
  bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14),
  bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12),
  labelLarge: TextStyle(fontFamily: 'WinkyRough', fontSize: 16),
  labelMedium: TextStyle(fontFamily: 'WinkyRough', fontSize: 14),
  labelSmall: TextStyle(fontFamily: 'WinkyRough', fontSize: 13),
);

/* ----------------------------- */
/* --- tesArte COLOR SCHEMES --- */
/* ----------------------------- */

// --- ☀️ LIGHT COLOR SCHEME ☀️ ---
final ColorScheme lightColorScheme = ColorScheme(
  primary: Color(0xFFAD4D4D),
  onPrimary: Color(0xFFECDAB6),

  secondary: Color(0xFFD98324),
  onSecondary: Color(0xFFEFDCAB),

  surface: Color(0xFFF2F6D0),
  onSurface: Color(0xFF443627),
  surfaceTint: Color(0xFF9EA189),
  surfaceBright: Color(0xFFF8FFC1),

  error: Colors.redAccent,
  onError: Colors.white,

  tertiary: Colors.black,

  brightness: Brightness.light,
);


// --- 🌙 DARK COLOR SCHEME 🌙️ ---
final ColorScheme darkColorScheme = ColorScheme(
  primary: Color(0xFFAD4D4D),
  onPrimary: Color(0xFFECDAB6),

  secondary: Color(0xFFD8A25E),
  onSecondary: Color(0xFF443627),

  surface: Color(0xFF343131),
  onSurface: Color(0xFF7C6E69),
  surfaceTint: Color(0xFF1E1B1B),
  surfaceBright: Color(0xFF413D3D),

  error: Colors.redAccent,
  onError: Colors.white,

  tertiary: Colors.white,

  brightness: Brightness.dark,
);