import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'app_config/router.dart';

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
        textTheme: tesArteTextTheme,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: darkColorScheme.onPrimary,
          selectionColor: darkColorScheme.primary,
          selectionHandleColor: darkColorScheme.onPrimary
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
  titleSmall: TextStyle(fontFamily: 'GrenzeGotisch', fontSize: 22),
  bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16),
  bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14),
  bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12),
  labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 14),
  labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12),
  labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11),
);

/* --------------------------- */
/* --- tesArte COLOR SCHEMES --- */
/* --------------------------- */

// --- ☀️ LIGHT COLOR SCHEME ☀️ ---
final ColorScheme lightColorScheme = ColorScheme(
  primary: Color(0xFFA04747),
  onPrimary: Color(0xFFECDAB6),

  secondary: Color(0xFFD98324),
  onSecondary: Color(0xFFEFDCAB),

  surface: Color(0xFFF2F6D0),
  onSurface: Color(0xFF443627),
  surfaceTint: Color(0xFF9EA189),

  error: Colors.redAccent,
  onError: Colors.white,

  tertiary: Colors.black,

  brightness: Brightness.light,
);


// --- 🌙 DARK COLOR SCHEME 🌙️ ---
final ColorScheme darkColorScheme = ColorScheme(
  primary: Color(0xFFA04747),
  onPrimary: Color(0xFFECDAB6),

  secondary: Color(0xFFD8A25E),
  onSecondary: Color(0xFF443627),

  surface: Color(0xFF343131),
  onSurface: Color(0xFF6B5E59),
  surfaceTint: Color(0xFF1E1B1B),

  error: Colors.redAccent,
  onError: Colors.white,

  tertiary: Colors.white,

  brightness: Brightness.dark,
);