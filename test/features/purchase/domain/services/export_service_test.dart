// test/features/purchase/domain/services/export_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/domain/services/export_service.dart';
import 'package:intl/intl.dart';

// La funzione `main` è il punto di ingresso per l'esecuzione dei test in questo file.
void main() {
  // `group` è un modo per organizzare test correlati. Tutti i test all'interno
  // di questo gruppo riguardano l'ExportService.
  group('ExportService', () {
    // 1. Definiamo il "Soggetto Sotto Test" (Subject Under Test - SUT)
    // In questo caso, è la nostra istanza di ExportService.
    final exportService = ExportService();

    // `test` definisce un singolo caso di test. La descrizione dovrebbe
    // spiegare cosa ci aspettiamo che succeda.
    test(
      'should correctly convert a purchase with gluten-free and regular items to a CSV string',
      () {
        // Ogni test segue lo schema "Arrange, Act, Assert" (Prepara, Agisci, Verifica).

        // ---- 1. ARRANGE (Prepara) ----
        // Creiamo tutti i dati di input di cui abbiamo bisogno.
        final purchase = PurchaseModel(
          id: 'test-id-123',
          date: DateTime(2025, 9, 22, 10, 30),
          store: 'Supermercato Test',
          total: 15.5, // Il totale complessivo non influisce sul CSV generato
          currency: 'EUR',
          items: [
            PurchaseItemModel(
              id: 'item-1',
              name: 'Pasta Senza Glutine',
              quantity: 2,
              unitPrice: 3.5,
              isGlutenFree: true,
              barcode: '111',
            ),
            PurchaseItemModel(
              id: 'item-2',
              name: 'Biscotti Normali',
              quantity: 1.5,
              unitPrice: 2.0,
              isGlutenFree: false,
            ),
            PurchaseItemModel(
              id: 'item-3',
              name: 'Pane SG',
              quantity: 1,
              unitPrice: 4.25,
              isGlutenFree: true,
              barcode: '333',
            ),
          ],
        );

        // Definiamo la stringa esatta che ci aspettiamo come output.
        // È FONDAMENTALE essere precisi qui, inclusi spazi e ritorni a capo.
        // Usiamo una stringa multi-linea `'''` per leggibilità.
        final expectedCsvString =
            '''Store,Supermercato Test
Date,${DateFormat.yMd().format(purchase.date)}
Total,15.5

Item Name,Quantity,Unit Price,Subtotal,Barcode
Pasta Senza Glutine,2.0,3.5,7.0,111
Biscotti Normali,1.5,2.0,3.0,
Pane SG,1.0,4.25,4.25,333''';

        // ---- 2. ACT (Agisci) ----
        // Eseguiamo il metodo che vogliamo testare.
        final resultCsvString = exportService.purchaseToCsv(purchase);

        // ---- 3. ASSERT (Verifica) ----
        // Verifichiamo che il risultato ottenuto (`resultCsvString`)
        // sia esattamente uguale al risultato che ci aspettavamo (`expectedCsvString`).
        // Se non sono uguali, il test fallirà.
        expect(resultCsvString, expectedCsvString);
      },
    );

    // Possiamo aggiungere altri test qui...
    test('should handle a purchase with no items', () {
      // ARRANGE
      final emptyPurchase = PurchaseModel(
        id: 'empty-id',
        date: DateTime(2025, 1, 1),
        store: 'Negozio Vuoto',
        total: 0.0,
        items: [], // Lista vuota!
      );

      final expectedCsvString =
          '''Store,Negozio Vuoto
Date,${DateFormat.yMd().format(emptyPurchase.date)}
Total,0.0

Item Name,Quantity,Unit Price,Subtotal,Barcode''';

      // ACT
      final resultCsvString = exportService.purchaseToCsv(emptyPurchase);

      // ASSERT
      expect(resultCsvString, expectedCsvString);
    });
  });
}
