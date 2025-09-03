import 'package:flutter/material.dart';

// Definiamo alcuni colori per riutilizzarli facilmente
const Color primaryColor = Colors.green;
const Color onPrimaryColor = Colors.white;
const Color secondaryColor = Colors.teal;
const Color backgroundColorLight = Color(0xFFF5F5F5);
const Color backgroundColorDark = Color(0xFF121212);
const Color cardColorLight = Colors.white;
const Color cardColorDark = Color(0xFF1E1E1E);

/// Una classe per centralizzare la configurazione dei temi dell'app.
/// In questo modo, se vogliamo cambiare il colore primario o un font,
/// lo modifichiamo in un unico posto.
class AppTheme {
  // Costruttore privato per evitare che si possa istanziare questa classe.
  // Vogliamo usarla solo per accedere alle sue proprietà statiche.
  AppTheme._();

  /// Definizione del TEMA CHIARO per l'applicazione.
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      background: backgroundColorLight,
      surface: cardColorLight,
      error: Colors.redAccent,
    ),
    scaffoldBackgroundColor: backgroundColorLight,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      foregroundColor: onPrimaryColor, // Colore per icone e testo nell'AppBar
      elevation: 4,
    ),
    cardTheme: const CardThemeData(
      color: cardColorLight,
      elevation: 1,
      margin: EdgeInsets.all(8),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  /// Definizione del TEMA SCURO per l'applicazione.
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      background: backgroundColorDark,
      surface: cardColorDark,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: backgroundColorDark,
    appBarTheme: const AppBarTheme(
      color: cardColorDark, // AppBar più scura nel tema dark
      elevation: 2,
    ),
    cardTheme: const CardThemeData(
      color: cardColorDark,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
