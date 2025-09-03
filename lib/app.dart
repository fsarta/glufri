import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_history_screen.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';

// --- I due import che risolvono gli errori ---
import 'package:glufri/core/config/app_theme.dart';
// ------------------------------------------

class GlufriApp extends ConsumerWidget {
  final bool hasSeenOnboarding;

  const GlufriApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Glufri',

      // Ora `AppTheme` è definito e queste righe non danno più errore
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      locale: locale,

      // Ora `AppLocalizations` è definito e queste righe non danno più errore
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: hasSeenOnboarding
          ? const PurchaseHistoryScreen()
          : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
