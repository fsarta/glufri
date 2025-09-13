// lib/features/backup/domain/sync_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/budget/data/models/budget_model.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_item_model.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SyncService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SyncService(this._firestore, this._auth);

  /// Helper per ottenere l'utente corrente e lanciare un'eccezione se non è loggato.
  User _getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Sync Operation Aborted: User is not authenticated.");
    }
    return user;
  }

  // =======================================================================
  // --- METODI PER IL CONFRONTO DEI TIMESTAMP (PER IL SYNC INTELLIGENTE) ---
  // =======================================================================

  /// Recupera la data dell'acquisto più recente presente su Firestore.
  Future<DateTime?> getLatestPurchaseDateFromCloud() async {
    final user = _getCurrentUser();
    debugPrint(
      "[Sync Check] Tentativo di recuperare l'ultimo timestamp degli acquisti da Firestore per l'utente ${user.uid}...",
    );

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('purchases')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final latestDate = (querySnapshot.docs.first.data()['date'] as Timestamp)
          .toDate();
      debugPrint(
        "[Sync Check] Trovato ultimo timestamp acquisto su Firestore: $latestDate",
      );
      return latestDate;
    }
    debugPrint("[Sync Check] Nessun acquisto trovato su Firestore.");
    return null;
  }

  /// Recupera la data dell'acquisto più recente salvato localmente su Hive.
  Future<DateTime?> getLatestPurchaseDateFromLocal() async {
    final user = _getCurrentUser();
    final boxName = 'purchases_${user.uid}';
    debugPrint(
      "[Sync Check] Tentativo di recuperare l'ultimo timestamp degli acquisti da Hive ($boxName)...",
    );

    if (!await Hive.boxExists(boxName)) {
      debugPrint(
        "[Sync Check] Box Hive '$boxName' non esiste. Nessun dato locale.",
      );
      return null;
    }

    final box = await Hive.openBox<PurchaseModel>(boxName);
    if (box.values.isNotEmpty) {
      final purchases = box.values.toList();
      purchases.sort((a, b) => b.date.compareTo(a.date));
      final latestDate = purchases.first.date;
      debugPrint(
        "[Sync Check] Trovato ultimo timestamp acquisto su Hive: $latestDate",
      );
      return latestDate;
    }
    debugPrint("[Sync Check] Box Hive '$boxName' è vuota.");
    return null;
  }

  // =====================================================================
  // --- OPERAZIONI DI SINCRONIZZAZIONE (BACKUP & RESTORE) ---
  // =====================================================================

  /// Esegue un BACKUP COMPLETO, caricando tutti i dati locali sul cloud.
  /// Sovrascrive i dati esistenti sul cloud.
  Future<void> backupToCloud() async {
    final user = _getCurrentUser();
    debugPrint("[Backup] INIZIO BACKUP COMPLETO per l'utente ${user.uid}...");
    final batch = _firestore.batch();

    // --- 1. Backup Acquisti ---
    final purchaseBox = await Hive.openBox<PurchaseModel>(
      'purchases_${user.uid}',
    );
    debugPrint(
      "[Backup] Trovati ${purchaseBox.length} acquisti da backuppare.",
    );
    for (final purchase in purchaseBox.values) {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .doc(purchase.id);
      // Assicurati che `purchase.toJson()` esista e funzioni!
      batch.set(docRef, purchase.toJson());
    }

    // --- 2. Backup Preferiti ---
    final favBox = await Hive.openBox<FavoriteProductModel>(
      'favorites_${user.uid}',
    );
    debugPrint("[Backup] Trovati ${favBox.length} preferiti da backuppare.");
    for (final fav in favBox.values) {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(fav.id);
      // Assicurati che `fav.toJson()` esista!
      batch.set(docRef, fav.toJson());
    }

    // --- 3. Backup Liste della Spesa ---
    // NOTA: Questo richiede che `ShoppingListModel` abbia un `toJson` che gestisca anche `HiveList`.
    // L'implementazione corretta di `toJson` è cruciale qui.
    final listBox = await Hive.openBox<ShoppingListModel>(
      'shopping_lists_${user.uid}',
    );
    debugPrint(
      "[Backup] Trovate ${listBox.length} liste della spesa da backuppare.",
    );
    for (final list in listBox.values) {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('shopping_lists')
          .doc(list.id);
      // Assicurati che `list.toJson()` esista!
      batch.set(docRef, list.toJson());
    }

    // --- 4. Backup Budget ---
    final budgetBox = await Hive.openBox<BudgetModel>('budgets_${user.uid}');
    debugPrint("[Backup] Trovati ${budgetBox.length} budget da backuppare.");
    for (final budget in budgetBox.values) {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('budgets')
          .doc(budget.id);
      // Assicurati che `budget.toJson()` esista!
      batch.set(docRef, budget.toJson());
    }

    // --- 5. Commit finale ---
    debugPrint("[Backup] Invio del batch di scrittura a Firestore...");
    await batch.commit();
    debugPrint("🚀 [Backup] BACKUP COMPLETATO CON SUCCESSO.");
  }

  /// Esegue un RESTORE COMPLETO, scaricando tutti i dati dal cloud e
  /// sovrascrivendo i dati locali.
  Future<void> restoreFromCloud() async {
    final user = _getCurrentUser();
    debugPrint("[Restore] INIZIO RESTORE COMPLETO per l'utente ${user.uid}...");

    // --- 1. Restore Acquisti ---
    final purchaseSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('purchases')
        .get();
    final cloudPurchases = purchaseSnapshot.docs
        .map((d) => PurchaseModel.fromJson(d.data()))
        .toList();
    debugPrint(
      "[Restore] Trovati ${cloudPurchases.length} acquisti nel cloud.",
    );
    final purchaseBox = await Hive.openBox<PurchaseModel>(
      'purchases_${user.uid}',
    );
    await purchaseBox.clear();
    await purchaseBox.putAll({for (var p in cloudPurchases) p.id: p});
    debugPrint("[Restore] Box acquisti locale aggiornata.");

    // --- 2. Restore Preferiti ---
    final favSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();
    final cloudFavorites = favSnapshot.docs
        .map((d) => FavoriteProductModel.fromJson(d.data()))
        .toList();
    debugPrint(
      "[Restore] Trovati ${cloudFavorites.length} preferiti nel cloud.",
    );
    final favBox = await Hive.openBox<FavoriteProductModel>(
      'favorites_${user.uid}',
    );
    await favBox.clear();
    await favBox.putAll({for (var f in cloudFavorites) f.id: f});
    debugPrint("[Restore] Box preferiti locale aggiornata.");

    // --- 3. Restore Liste della Spesa (e i loro item) ---
    // Questo è il più complesso. Dobbiamo ricostruire i dati e le relazioni di HiveList.
    final listSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('shopping_lists')
        .get();
    final cloudListsData = listSnapshot.docs.map((d) => d.data()).toList();
    debugPrint(
      "[Restore] Trovate ${cloudListsData.length} liste della spesa nel cloud.",
    );

    final listBox = await Hive.openBox<ShoppingListModel>(
      'shopping_lists_${user.uid}',
    );
    final itemBox = await Hive.openBox<ShoppingListItemModel>(
      'shopping_list_items_${user.uid}',
    );
    await listBox.clear();
    await itemBox
        .clear(); // Svuotiamo anche gli item per una ricostruzione pulita

    for (final listData in cloudListsData) {
      // 1. Prima salviamo tutti gli item di questa lista nella loro box.
      final List<ShoppingListItemModel> items =
          (listData['items'] as List<dynamic>?)
              ?.map((itemJson) => ShoppingListItemModel.fromJson(itemJson))
              .toList() ??
          [];

      await itemBox.addAll(items); // Aggiunge tutti gli item alla loro box.

      // 2. Creiamo un nuovo HiveList che ora può referenziare gli item appena salvati.
      final hiveListItems = HiveList(itemBox, objects: items);

      // 3. Creiamo l'oggetto ShoppingListModel con la relazione HiveList corretta.
      final newList = ShoppingListModel.fromJson(
        listData,
        items: hiveListItems,
      );
      await listBox.put(newList.id, newList);
    }
    debugPrint("[Restore] Box liste e item locali aggiornate.");

    // --- 4. Restore Budget ---
    final budgetSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('budgets')
        .get();
    final cloudBudgets = budgetSnapshot.docs
        .map((d) => BudgetModel.fromJson(d.data()))
        .toList();
    debugPrint("[Restore] Trovati ${cloudBudgets.length} budget nel cloud.");
    final budgetBox = await Hive.openBox<BudgetModel>('budgets_${user.uid}');
    await budgetBox.clear();
    await budgetBox.putAll({for (var b in cloudBudgets) b.id: b});
    debugPrint("[Restore] Box budget locale aggiornata.");

    debugPrint("🚀 [Restore] RESTORE COMPLETATO CON SUCCESSO.");
  }
}

// =======================================================================
// --- PROVIDERS DI RIVERPOD ---
// =======================================================================

/// Provider per l'istanza di Firestore.
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

/// Provider per l'istanza di FirebaseAuth.
final authProvider = Provider((ref) => FirebaseAuth.instance);

/// Provider principale per il SyncService.
/// È un provider sincrono perché le sue dipendenze (firestore, auth)
/// sono disponibili immediatamente all'avvio dell'app.
final syncServiceProvider = Provider<SyncService>((ref) {
  debugPrint("[Provider] Istanza di SyncService creata/richiesta.");
  return SyncService(ref.watch(firestoreProvider), ref.watch(authProvider));
});
