import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/data/repositories/purchase_repository_impl.dart';
import 'package:glufri/features/purchase/domain/repositories/purchase_repository.dart';
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
