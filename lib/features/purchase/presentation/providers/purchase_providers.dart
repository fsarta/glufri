import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/data/repositories/purchase_repository_impl.dart';
import 'package:glufri/features/purchase/domain/repositories/purchase_repository.dart';
import 'package:glufri/features/purchase/presentation/models/purchase_group_models.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_filter_provider.dart';

// 1. Provider per il DataSource locale (ORA È DINAMICO)
final purchaseLocalDataSourceProvider = Provider<PurchaseLocalDataSource>((
  ref,
) {
  // Ascolta il provider dell'utente
  final user = ref.watch(userProvider);

  // Se l'utente è loggato, usa il suo UID. Altrimenti, usa la costante 'local'.
  final userId = user?.uid ?? localUserId;

  return PurchaseLocalDataSourceImpl(userId: userId);
});

// 2. Provider per il Repository (dipende dal datasource)
final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  final localDataSource = ref.watch(purchaseLocalDataSourceProvider);
  return PurchaseRepositoryImpl(localDataSource);
});

// 3. Provider della lista di acquisti  FILTRATA
final purchaseListProvider = FutureProvider<List<PurchaseModel>>((ref) async {
  // Ascolta sia i filtri che il repository
  final filters = ref.watch(purchaseFilterProvider);
  final repository = ref.watch(purchaseRepositoryProvider);

  // Ottiene sempre TUTTI gli acquisti dal db (efficiente per Hive)
  final allPurchases = await repository.getPurchases();

  // Applica i filtri in memoria (lato client)
  /* if (filters.searchQuery.isEmpty && filters.dateRange == null) {
    return allPurchases; // Nessun filtro, restituisce tutto
  } */

  return allPurchases.where((purchase) {
    // Filtro di ricerca (cerca nel negozio o nei nomi dei prodotti)
    final searchMatch =
        filters.searchQuery.isEmpty ||
        (purchase.store?.toLowerCase().contains(
              filters.searchQuery.toLowerCase(),
            ) ??
            false) ||
        purchase.items.any(
          (item) => item.name.toLowerCase().contains(
            filters.searchQuery.toLowerCase(),
          ),
        );

    // Filtro per data
    final dateMatch =
        filters.dateRange == null ||
        (purchase.date.isAfter(
              filters.dateRange!.start.subtract(const Duration(seconds: 1)),
            ) &&
            purchase.date.isBefore(
              filters.dateRange!.end.add(const Duration(days: 1)),
            ));

    return searchMatch && dateMatch;
  }).toList();
});

// Ascolta la lista completa e trova l'acquisto per ID.
final singlePurchaseProvider = Provider.autoDispose.family<PurchaseModel?, String>((
  ref,
  purchaseId,
) {
  // Ascolta la lista intera
  final purchasesListAsync = ref.watch(purchaseListProvider);

  // Quando la lista è disponibile, cerca l'elemento specifico
  return purchasesListAsync.whenData((purchases) {
    try {
      // Usa .firstWhere per trovare l'acquisto. Se non lo trova, lancia un errore.
      return purchases.firstWhere((p) => p.id == purchaseId);
    } catch (e) {
      // Se l'acquisto non è più nella lista (es. è stato eliminato), restituisce null.
      return null;
    }
  }).value; // .value espone il dato in modo sincrono o null se in caricamento/errore
});

/// Provider che prende la lista piatta di acquisti e la raggruppa
/// per anno e mese, calcolando i totali aggregati.
final groupedPurchaseProvider = Provider.autoDispose<List<YearlyPurchaseGroup>>((
  ref,
) {
  // 1. Osserva la lista di acquisti (già filtrata dalla ricerca, se attiva)
  final purchasesListAsync = ref.watch(purchaseListProvider);

  // Se la lista non è ancora pronta o è vuota, restituisce una lista vuota
  final purchases = purchasesListAsync.valueOrNull ?? [];
  if (purchases.isEmpty) {
    return [];
  }

  // 2. Raggruppa gli acquisti prima per anno, poi per mese.
  // Usiamo il potente metodo `groupListsBy` dal pacchetto `collection`.
  final yearlyMap = purchases.groupListsBy((p) => p.date.year);

  // 3. Trasforma la mappa in una lista di oggetti YearlyPurchaseGroup
  return yearlyMap.entries.map((yearEntry) {
      final year = yearEntry.key;
      final yearPurchases = yearEntry.value;

      // Raggruppa gli acquisti dell'anno per mese
      final monthlyMap = yearPurchases.groupListsBy((p) => p.date.month);

      // 4. Per ogni mese, calcola i totali e crea un MonthlyPurchaseGroup
      final monthlyGroups =
          monthlyMap.entries.map((monthEntry) {
              final month = monthEntry.key;
              final monthPurchases = monthEntry.value;

              // Calcola i totali per il mese corrente
              final totalGf = monthPurchases.map((p) => p.totalGlutenFree).sum;
              final totalReg = monthPurchases.map((p) => p.totalRegular).sum;

              return MonthlyPurchaseGroup(
                year: year,
                month: month,
                purchases: monthPurchases, // Gli acquisti di questo mese
                totalGlutenFree: totalGf,
                totalRegular: totalReg,
                totalOverall: totalGf + totalReg,
              );
            }).toList()
            // Ordina i mesi in ordine decrescente (dal più recente al più vecchio)
            ..sort((a, b) => b.month.compareTo(a.month));

      // 5. Calcola i totali per l'intero anno sommando i totali dei mesi
      final yearTotalGf = monthlyGroups.map((m) => m.totalGlutenFree).sum;
      final yearTotalReg = monthlyGroups.map((m) => m.totalRegular).sum;

      return YearlyPurchaseGroup(
        year: year,
        months: monthlyGroups, // La lista dei gruppi mensili
        totalGlutenFree: yearTotalGf,
        totalRegular: yearTotalReg,
        totalOverall: yearTotalGf + yearTotalReg,
      );
    }).toList()
    // Ordina gli anni in ordine decrescente (dal più recente al più vecchio)
    ..sort((a, b) => b.year.compareTo(a.year));
});

/* /// Provider che, data una query di ricerca, aggrega tutti gli item
/// corrispondenti in riepiloghi per prodotto.
final searchedProductsSummaryProvider = Provider.autoDispose<List<SearchedProductSummary>>((
  ref,
) {
  // 1. Osserva sia la lista di acquisti che i filtri
  final purchases = ref.watch(purchaseListProvider).valueOrNull ?? [];
  final searchQuery = ref
      .watch(purchaseFilterProvider)
      .searchQuery
      .toLowerCase();

  if (searchQuery.isEmpty || purchases.isEmpty) {
    return []; // Nessuna ricerca, nessun risultato
  }

  // 2. "Appiattiamo" la struttura: creiamo una lista di tutti gli item di tutti gli acquisti
  // e una mappa per recuperare il contesto di ogni acquisto tramite il suo ID
  final allItems = <PurchaseItemModel>[];
  final purchaseMap = {for (var p in purchases) p.id: p};

  for (final purchase in purchases) {
    allItems.addAll(purchase.items);
  }

  // 3. Filtra solo gli item il cui nome contiene la query di ricerca
  final matchingItems = allItems
      .where((item) => item.name.toLowerCase().contains(searchQuery))
      .toList();

  // 4. Raggruppa gli item filtrati per nome del prodotto
  final groupedByName = matchingItems.groupListsBy((item) => item.name);

  // 5. Trasforma ogni gruppo in un oggetto `SearchedProductSummary`
  return groupedByName.entries.map((entry) {
    final productName = entry.key;
    final items = entry.value;

    // Aggrega i dati
    final totalSpent = items.map((i) => i.subtotal).sum;
    final totalQuantity = items.map((i) => i.quantity).sum;

    // Per ottenere il purchaseContext corretto, usiamo la mappa creata prima
    final contextMap = <String, PurchaseModel>{};
    for (final item in items) {
      // Ogni HiveObject ha un riferimento alla sua box e chiave, ma per risalire al PurchaseModel
      // è più robusto avere una mappa come abbiamo fatto. Dobbiamo però associare l'item al suo purchase.
      // Modifichiamo l'approccio per essere più robusti.
    }

    return SearchedProductSummary(
      productName: productName,
      items: items,
      purchaseCount: items.length,
      totalSpent: totalSpent,
      totalQuantity: totalQuantity,
      purchaseContext: {}, // Lo sistemiamo dopo
    );
  }).toList()..sort(
    (a, b) => b.totalSpent.compareTo(a.totalSpent),
  ); // Ordina per spesa
}); */

// -- Correzione Robusta per il Contesto --
// Il modo migliore per passare il contesto è modificare la logica di appiattimento.

final searchedProductsSummaryProvider =
    Provider.autoDispose<List<SearchedProductSummary>>((ref) {
      final purchases = ref.watch(purchaseListProvider).valueOrNull ?? [];
      final searchQuery = ref
          .watch(purchaseFilterProvider)
          .searchQuery
          .toLowerCase();

      if (searchQuery.isEmpty || purchases.isEmpty) return [];

      // Mappa ogni item a un oggetto che contiene l'item e il suo acquisto genitore
      final allItemsWithContext = purchases.expand((purchase) {
        return purchase.items.map(
          (item) => {'item': item, 'purchase': purchase},
        );
      });

      final matchingItems = allItemsWithContext.where((data) {
        final item = data['item'] as PurchaseItemModel;
        return item.name.toLowerCase().contains(searchQuery);
      }).toList();

      final groupedByName = matchingItems.groupListsBy((data) {
        final item = data['item'] as PurchaseItemModel;
        return item.name;
      });

      return groupedByName.entries.map((entry) {
        final productName = entry.key;
        final dataEntries = entry.value;

        final items = dataEntries
            .map((d) => d['item'] as PurchaseItemModel)
            .toList();
        final contextMap = {
          for (var d in dataEntries)
            (d['item'] as PurchaseItemModel).id: d['purchase'] as PurchaseModel,
        };

        final totalSpent = items.map((i) => i.subtotal).sum;
        final totalQuantity = items.map((i) => i.quantity).sum;

        return SearchedProductSummary(
          productName: productName,
          items: items,
          purchaseCount: items.length,
          totalSpent: totalSpent,
          totalQuantity: totalQuantity,
          purchaseContext: contextMap,
        );
      }).toList()..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    });
