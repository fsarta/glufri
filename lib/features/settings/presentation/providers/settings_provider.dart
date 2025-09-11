import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider per il ThemeMode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    state = ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
    state = themeMode;
  }
}

// Provider per la lingua
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null && languageCode != 'system') {
      state = Locale(languageCode);
      Intl.defaultLocale = languageCode; // Imposta anche all'avvio
    } else {
      // Se è system, non impostiamo nulla, così prende quello di default
      state = null;
      // Il default locale è già stato impostato in main.dart
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();

    if (locale.languageCode == 'system') {
      await prefs.remove('languageCode');
      state = null; // null significa 'usa la lingua di sistema'
      // Ripristina il default locale a quello di sistema
      Intl.defaultLocale = WidgetsBinding.instance.platformDispatcher.locale
          .toLanguageTag();
    } else {
      await prefs.setString('languageCode', locale.languageCode);
      state = locale;
      // --- MODIFICA CHIAVE ---
      // Aggiorna il defaultLocale ogni volta che l'utente cambia lingua!
      Intl.defaultLocale = locale.languageCode;
    }
  }

  Future<void> setLocaleFromString(String? languageCode) async {
    if (languageCode == null || languageCode == 'system') {
      await setLocale(
        Locale('system'),
      ); // Tratta null e 'system' allo stesso modo
    } else {
      await setLocale(Locale(languageCode));
    }
  }
}
