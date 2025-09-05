// test/features/purchase/data/models/purchase_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';

void main() {
  // Organizziamo i test per la classe PurchaseModel
  group('PurchaseModel Logic', () {
    // Caso di test 1: Un acquisto con un mix di prodotti
    test(
      'correctly calculates gluten-free and regular totals for a mixed purchase',
      () {
        // 1. ARRANGE: Prepara i dati di input
        final purchase = PurchaseModel(
          id: '1',
          date: DateTime.now(),
          items: [
            // Prodotto SG: 2 * 3.0 = 6.0
            PurchaseItemModel(
              id: 'a',
              name: 'Pasta SG',
              quantity: 2,
              unitPrice: 3.0,
              isGlutenFree: true,
            ),
            // Prodotto normale: 1 * 5.0 = 5.0
            PurchaseItemModel(
              id: 'b',
              name: 'Biscotti',
              quantity: 1,
              unitPrice: 5.0,
              isGlutenFree: false,
            ),
            // Altro prodotto SG: 3 * 1.5 = 4.5
            PurchaseItemModel(
              id: 'c',
              name: 'Pane SG',
              quantity: 3,
              unitPrice: 1.5,
              isGlutenFree: true,
            ),
          ],
          // I totali e gli altri campi non ci interessano per questo test
          total: 15.5,
        );

        // 2. ACT: L'azione è semplicemente accedere ai getter.
        // Non c'è un metodo da chiamare, la logica è nel calcolo dei getter.
        final glutenFreeTotal = purchase.totalGlutenFree;
        final regularTotal = purchase.totalRegular;

        // 3. ASSERT: Verifica che i risultati siano quelli attesi
        // Ci aspettiamo che il totale SG sia 6.0 + 4.5 = 10.5
        expect(glutenFreeTotal, 10.5);
        // Ci aspettiamo che il totale normale sia 5.0
        expect(regularTotal, 5.0);
      },
    );

    // Caso di test 2: Un acquisto con SOLO prodotti senza glutine
    test('correctly calculates totals when all items are gluten-free', () {
      // 1. ARRANGE
      final purchase = PurchaseModel(
        id: '2',
        date: DateTime.now(),
        items: [
          PurchaseItemModel(
            id: 'a',
            name: 'Pizza SG',
            quantity: 1,
            unitPrice: 6.5,
            isGlutenFree: true,
          ),
          PurchaseItemModel(
            id: 'b',
            name: 'Birra SG',
            quantity: 4,
            unitPrice: 2.0,
            isGlutenFree: true,
          ),
        ],
        total: 14.5,
      );

      // 2. ACT
      final glutenFreeTotal = purchase.totalGlutenFree;
      final regularTotal = purchase.totalRegular;

      // 3. ASSERT
      // Ci aspettiamo che il totale SG sia 6.5 + 8.0 = 14.5
      expect(glutenFreeTotal, 14.5);
      // Ci aspettiamo che il totale normale sia 0
      expect(regularTotal, 0);
    });

    // Caso di test 3: Un acquisto senza prodotti
    test('returns zero for totals when there are no items', () {
      // 1. ARRANGE
      final purchase = PurchaseModel(
        id: '3',
        date: DateTime.now(),
        items: [], // Lista vuota
        total: 0,
      );

      // 2. ACT & 3. ASSERT
      expect(purchase.totalGlutenFree, 0);
      expect(purchase.totalRegular, 0);
    });
  });
}
