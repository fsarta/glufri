import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/widgets/ad_banner_widget.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_history_screen.dart';

void main() {
  testWidgets(
    'PurchaseHistoryScreen shows list of purchases and hides ad for Pro users',
    (WidgetTester tester) async {
      // Arrange: Prepara i dati di mock
      final mockPurchases = [
        PurchaseModel(
          id: '1',
          date: DateTime.now(),
          store: 'Supermercato Mock',
          total: 12.99,
          items: [],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Sovrascrivi il provider della lista acquisti per restituire dati di mock
            purchaseListProvider.overrideWith(
              (ref) => Future.value(mockPurchases),
            ),
            // Sovrascrivi il provider di monetizzazione per simulare un utente Pro
            isProUserProvider.overrideWithValue(true),
          ],
          child: MaterialApp(
            // Fornisci i delegati di localizzazione necessari per S.of(context)
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('it')],
            home: PurchaseHistoryScreen(),
          ),
        ),
      );

      // Attendi che il Future si completi e l'UI si aggiorni
      await tester.pumpAndSettle();

      // Assert: Verifica che gli elementi della UI siano corretti
      expect(find.text('Supermercato Mock'), findsOneWidget);
      expect(find.text('12.99 EUR'), findsOneWidget);
      // Verifica che la pubblicità NON sia presente per un utente pro
      expect(find.byType(AdBannerWidget), findsNothing);
    },
  );
}
