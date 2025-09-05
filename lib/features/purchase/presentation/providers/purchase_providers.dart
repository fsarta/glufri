import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
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
  if (filters.searchQuery.isEmpty && filters.dateRange == null) {
    return allPurchases; // Nessun filtro, restituisce tutto
  }

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
              filters.dateRange!.start.subtract(const Duration(days: 1)),
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
