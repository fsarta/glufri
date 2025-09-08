import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';
import 'package:glufri/features/settings/presentation/screens/settings_screen.dart';

// Importiamo la libreria mocktail che è più moderna di mockito
// E più facile da usare per questi scenari. Aggiungila alle dev_dependencies.
import 'package:mocktail/mocktail.dart';

import 'package:glufri/core/l10n/app_localizations.dart';

// --- CLASSI MOCK MANUALI ---
// Questa è una classe finta che si comporta come il nostro Notifier
// ma ci dà il pieno controllo sui metodi.
class MockThemeModeNotifier extends StateNotifier<ThemeMode>
    with Mock
    implements ThemeModeNotifier {
  MockThemeModeNotifier(ThemeMode initialState) : super(initialState);
}

class MockLocaleNotifier extends StateNotifier<Locale?>
    with Mock
    implements LocaleNotifier {
  MockLocaleNotifier(Locale? initialState) : super(initialState);
}

void main() {
  // Questo blocco viene eseguito una sola volta prima di tutti i test del file.
  setUpAll(() {
    // Insegniamo a mocktail come creare dei valori "segnaposto" per ThemeMode e Locale.
    // Il valore esatto non importa (poteva essere .light, .dark, etc.).
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(const Locale('en'));
  });

  // Prepariamo le istanze dei mock
  late MockThemeModeNotifier mockThemeModeNotifier;
  late MockLocaleNotifier mockLocaleNotifier;

  // Questa è una funzione helper che renderà il test più leggibile
  Future<void> pumpSettingsScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Per StateNotifierProvider, si usa .overrideWith((ref) => notifierIstance)
          themeModeProvider.overrideWith((ref) => mockThemeModeNotifier),
          localeProvider.overrideWith((ref) => mockLocaleNotifier),

          authStateChangesProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('it'),
          home: SettingsScreen(),
        ),
      ),
    );
  }

  group('SettingsScreen', () {
    testWidgets('displays initial values from providers correctly', (
      tester,
    ) async {
      // 1. ARRANGE: Crea le istanze dei nostri Notifier mock con uno stato iniziale
      // Lo stato viene passato direttamente al costruttore, risolvendo il "Bad State".
      mockThemeModeNotifier = MockThemeModeNotifier(ThemeMode.dark);
      mockLocaleNotifier = MockLocaleNotifier(const Locale('it'));

      // 2. ACT
      await pumpSettingsScreen(tester);

      // 3. ASSERT
      expect(find.text('Scuro'), findsOneWidget);
      expect(find.text('Italiano'), findsOneWidget);
    });

    testWidgets('calls setThemeMode on notifier when a new theme is selected', (
      tester,
    ) async {
      // 1. ARRANGE
      mockThemeModeNotifier = MockThemeModeNotifier(ThemeMode.system);
      mockLocaleNotifier = MockLocaleNotifier(const Locale('it'));

      // Dobbiamo preparare il nostro mock per la chiamata a setThemeMode.
      // Diciamo a mocktail che quando setThemeMode viene chiamato con qualsiasi
      // valore di ThemeMode, non deve fare nulla e restituire un Future completato.
      when(
        () => mockThemeModeNotifier.setThemeMode(any()),
      ).thenAnswer((_) async {});

      await pumpSettingsScreen(tester);

      // 2. ACT
      await tester.tap(find.text('Sistema'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chiaro').last);
      await tester.pumpAndSettle();

      // 3. ASSERT
      // La sintassi di verifica è leggermente diversa con mocktail
      verify(
        () => mockThemeModeNotifier.setThemeMode(ThemeMode.light),
      ).called(1);
    });
  });
}
