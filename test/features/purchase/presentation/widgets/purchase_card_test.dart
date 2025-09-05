// test/features/purchase/presentation/widgets/purchase_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/core/l10n/app_localizations.dart'; // <-- IMPORTANTE
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/presentation/widgets/purchase_card.dart';

// --- VERSIONE AGGIORNATA DELLA FUNZIONE HELPER ---
Widget createTestableWidget({required Widget child}) {
  return MaterialApp(
    // Aggiungi i delegati per la localizzazione
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // Specifichiamo l'italiano come lingua di test per avere risultati prevedibili
    locale: const Locale('it'),
    home: Scaffold(body: child),
  );
}

void main() {
  group('PurchaseCard', () {
    testWidgets(
      'displays smart title, total, date, and product count correctly',
      (WidgetTester tester) async {
        // 1. ARRANGE
        final purchase = PurchaseModel(
          id: '1',
          date: DateTime(2025, 9, 25, 18, 0),
          store: 'Glufri Store',
          total: 100.50,
          items: [
            PurchaseItemModel(
              id: 'a',
              name: 'Item 1',
              quantity: 1,
              unitPrice: 100.50,
            ),
            PurchaseItemModel(
              id: 'b',
              name: 'Item 2',
              quantity: 1,
              unitPrice: 0,
            ),
          ],
        );

        // 2. ACT
        await tester.pumpWidget(
          createTestableWidget(child: PurchaseCard(purchase: purchase)),
        );

        // 3. ASSERT
        expect(find.text('Glufri Store: Item 1, Item 2'), findsOneWidget);
        expect(find.text('100.50 €'), findsOneWidget);
        expect(find.text('25/09/2025 18:00'), findsOneWidget);

        expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
        expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

        // Ora usiamo la chiave di localizzazione corretta, perché l'abbiamo caricata!
        expect(find.text('2 prodotti'), findsOneWidget);
      },
    );

    testWidgets('displays gluten-free summary when applicable', (
      WidgetTester tester,
    ) async {
      // 1. ARRANGE
      final purchase = PurchaseModel(
        id: '2',
        date: DateTime.now(),
        total: 50.0,
        items: [
          PurchaseItemModel(
            id: 'a',
            name: 'Prodotto SG',
            quantity: 1,
            unitPrice: 30.0,
            isGlutenFree: true,
          ),
          PurchaseItemModel(
            id: 'b',
            name: 'Prodotto Normale',
            quantity: 1,
            unitPrice: 20.0,
            isGlutenFree: false,
          ),
        ],
      );

      // 2. ACT
      await tester.pumpWidget(
        createTestableWidget(child: PurchaseCard(purchase: purchase)),
      );

      // 3. ASSERT
      // Ora i find.text useranno le stringhe esatte come da traduzione in italiano.
      expect(find.text('Senza Glutine: '), findsOneWidget);
      expect(find.text('30.00 €'), findsOneWidget);
      expect(find.text('Altro: '), findsOneWidget);
      expect(find.text('20.00 €'), findsOneWidget);
    });

    // AGGIUNGO UN TEST PER IL CASO OPPOSTO
    testWidgets(
      'does NOT display gluten-free summary when there are no gluten-free items',
      (WidgetTester tester) async {
        // 1. ARRANGE
        final purchase = PurchaseModel(
          id: '3',
          date: DateTime.now(),
          total: 20.0,
          items: [
            PurchaseItemModel(
              id: 'b',
              name: 'Prodotto Normale',
              quantity: 1,
              unitPrice: 20.0,
              isGlutenFree: false,
            ),
          ],
        );

        // 2. ACT
        await tester.pumpWidget(
          createTestableWidget(child: PurchaseCard(purchase: purchase)),
        );

        // 3. ASSERT
        // Ora verifichiamo che i widget NON esistano!
        expect(
          find.text('Senza Glutine: '),
          findsNothing,
        ); // `findsNothing` è il matcher per "0 widget trovati"
        expect(find.text('Altro: '), findsNothing);
      },
    );
  });
}
