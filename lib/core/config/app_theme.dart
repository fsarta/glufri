import 'package:flutter/material.dart';

// Definiamo alcuni colori per riutilizzarli facilmente
/* const Color primaryColor = Colors.green;
const Color onPrimaryColor = Colors.white;
const Color secondaryColor = Colors.teal;
const Color backgroundColorLight = Color(0xFFF5F5F5);
const Color backgroundColorDark = Color(0xFF121212);
const Color cardColorLight = Colors.white;
const Color cardColorDark = Color(0xFF1E1E1E);
const Color errorColorLight = Colors.redAccent;
const Color errorColorDark = Colors.red; */

const Color primaryColor = Color(
  0xFF8BC34A,
); // Verde acido (Lime Green), più vibrante e naturale
const Color onPrimaryColor = Colors.white; // Perfetto per il testo
const Color secondaryColor = Color(
  0xFF4CAF50,
); // Un verde più scuro, come contrasto o per icone
const Color backgroundColorLight = Color(
  0xFFF9FBE7,
); // Un bianco sporco, più caldo e meno asettico
const Color backgroundColorDark = Color(
  0xFF263238,
); // Grigio scuro-blu, più moderno del nero
const Color cardColorLight = Colors.white; // Funziona bene
const Color cardColorDark = Color(
  0xFF37474F,
); // Grigio scuro per le card, si abbina al background
const Color errorColorLight = Color(
  0xFFD32F2F,
); // Rosso profondo per gli errori
const Color errorColorDark = Color(
  0xFFE57373,
); // Rosso più chiaro per l'errore in modalità scura

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
      error: errorColorLight,
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
      error: errorColorDark,
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
