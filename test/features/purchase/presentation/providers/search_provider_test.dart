import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/domain/repositories/purchase_repository.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_filter_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:mockito/mockito.dart';

// Mock del PurchaseRepository per fornire dati finti
class MockPurchaseRepository extends Mock implements PurchaseRepository {}

void main() {
  group('searchedProductsSummaryProvider', () {
    // Dati di test
    final purchase1 = PurchaseModel(
      id: 'p1',
      date: DateTime.now(),
      total: 10,
      items: [
        PurchaseItemModel(
          id: 'i1',
          name: 'Biscotti al cioccolato',
          unitPrice: 2.5,
          quantity: 2,
          barcode: "111",
        ), // 5.0
      ],
    );
    final purchase2 = PurchaseModel(
      id: 'p2',
      date: DateTime.now(),
      total: 12,
      items: [
        PurchaseItemModel(
          id: 'i2',
          name: 'Pasta SG',
          unitPrice: 3.0,
          quantity: 1,
        ),
        PurchaseItemModel(
          id: 'i3',
          name: 'Biscotti semplici',
          unitPrice: 2.0,
          quantity: 1,
          barcode: "222",
        ), // 2.0
      ],
    );
    final purchase3 = PurchaseModel(
      id: 'p3',
      date: DateTime.now(),
      total: 7,
      items: [
        PurchaseItemModel(
          id: 'i4',
          name: 'Biscotti al cioccolato',
          unitPrice: 2.5,
          quantity: 1,
        ), // 2.5
      ],
    );

    final allPurchases = [purchase1, purchase2, purchase3];

    // --- TEST 1 AGGIORNATO ---
    test('should return correct summary for a product name search', () async {
      // <-- AGGIUNGI async
      // 1. ARRANGE
      final container = ProviderContainer(
        overrides: [
          purchaseListProvider.overrideWith(
            (ref) => Future.value(allPurchases),
          ),
          purchaseFilterProvider.overrideWith((ref) {
            final notifier = PurchaseFilterNotifier();
            notifier.setSearchQuery('Biscotti');
            return notifier;
          }),
        ],
      );

      // --- NUOVA PARTE CHIAVE ---
      // 1.5. Attendiamo che la dipendenza sia pronta.
      // Leggiamo il `.future` del provider che fornisce i dati.
      // Questo assicura che quando leggeremo l'altro provider, questo avrà i dati disponibili.
      await container.read(purchaseListProvider.future);

      // 2. ACT: Ora che le dipendenze sono caricate, leggiamo il nostro provider.
      final result = container.read(searchedProductsSummaryProvider);

      // 3. ASSERT (invariato)
      expect(result.length, 2);
      final chocoSummary = result.firstWhere(
        (s) => s.productName == 'Biscotti al cioccolato',
      );
      expect(chocoSummary.purchaseCount, 2);
      expect(chocoSummary.totalSpent, 7.5);
      expect(chocoSummary.totalQuantity, 3);

      final simpleSummary = result.firstWhere(
        (s) => s.productName == 'Biscotti semplici',
      );
      expect(simpleSummary.purchaseCount, 1);
      expect(simpleSummary.totalSpent, 2.0);
    });

    // --- TEST 2 AGGIORNATO ---
    test('should return correct summary for a barcode search', () async {
      // <-- AGGIUNGI async
      // 1. ARRANGE
      final container = ProviderContainer(
        overrides: [
          purchaseListProvider.overrideWith(
            (ref) => Future.value(allPurchases),
          ),
          purchaseFilterProvider.overrideWith((ref) {
            final notifier = PurchaseFilterNotifier();
            notifier.setSearchQuery('111');
            return notifier;
          }),
        ],
      );

      // 1.5. ATTENDIAMO
      await container.read(purchaseListProvider.future);

      // 2. ACT
      final result = container.read(searchedProductsSummaryProvider);

      // 3. ASSERT (invariato)
      expect(result.length, 1);
      expect(result.first.productName, 'Biscotti al cioccolato');
      expect(
        result.first.purchaseCount,
        1,
      ); // Corretto, era 2 prima per errore di copia
    });
  });
}
