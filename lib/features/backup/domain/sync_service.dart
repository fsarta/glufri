// lib/features/backup/domain/sync_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lastSyncTimestampKey = 'lastSyncTimestamp';

class SyncService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SyncService(this._firestore, this._auth);

  // Metodo HELPER per ottenere il riferimento alla collezione dell'utente
  CollectionReference<Map<String, dynamic>> _userPurchasesCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated for sync operation");
    }
    return _firestore.collection('users').doc(user.uid).collection('purchases');
  }

  /// Recupera la data dell'acquisto più recente presente su Firestore.
  /// Restituisce `null` se non ci sono acquisti.
  Future<DateTime?> getLatestPurchaseDateFromCloud() async {
    final querySnapshot = await _userPurchasesCollection()
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      // Le date in Firestore sono salvate come Timestamp
      return (data['date'] as Timestamp).toDate();
    }
    return null;
  }

  /// Recupera la data dell'acquisto più recente salvato localmente su Hive.
  /// Restituisce `null` se non ci sono acquisti.
  Future<DateTime?> getLatestPurchaseDateFromLocal() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final boxName = 'purchases_${user.uid}';
    if (!await Hive.boxExists(boxName)) return null;

    final box = await Hive.openBox<PurchaseModel>(boxName);
    if (box.values.isNotEmpty) {
      final purchases = box.values.toList();
      // Ordiniamo in memoria (Hive non ordina nativamente)
      purchases.sort((a, b) => b.date.compareTo(a.date));
      return purchases.first.date;
    }
    return null;
  }

  /// Carica tutti i dati locali su Firestore, sovrascrivendoli.
  Future<void> backupToCloud() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Nessun utente loggato per il backup.');
    }

    // Apri la box Hive dell'utente
    final box = await Hive.openBox<PurchaseModel>('purchases_${user.uid}');
    final purchases = box.values.toList();

    debugPrint(
      'Inizio backup di ${purchases.length} acquisti per utente ${user.uid}...',
    );

    // Usa una scrittura batch per efficienza e atomicità
    final batch = _firestore.batch();

    for (final purchase in purchases) {
      final docRef = _userPurchasesCollection().doc(purchase.id);
      batch.set(docRef, purchase.toJson());
    }

    await batch.commit();
    debugPrint('Backup completato.');
  }

  /// Scarica i dati da Firestore e sostituisce quelli locali.
  /// Se [isSilent] è true, non mostrerà debug print aggressivi (in futuro).
  Future<void> restoreFromCloud({bool isSilent = false}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Nessun utente loggato per il ripristino.');
    }

    if (!isSilent) {
      debugPrint('Inizio ripristino manuale per utente ${user.uid}...');
    }

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('purchases')
        .get();

    final cloudPurchases = querySnapshot.docs
        .map((doc) => PurchaseModel.fromJson(doc.data()))
        .toList();

    debugPrint('Trovati ${cloudPurchases.length} acquisti nel cloud.');

    final box = await Hive.openBox<PurchaseModel>('purchases_${user.uid}');
    // Svuota la box locale prima di popolarla (strategia 'sostituisci')
    await box.clear();

    // Inserisci tutti i dati scaricati in un'unica operazione
    await box.putAll({for (var p in cloudPurchases) p.id: p});

    if (!isSilent) {
      debugPrint('Ripristino manuale completato.');
    }
  }

  Future<int> restoreFromCloudAndGetCount() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint(
        '[SyncService] Errore: restoreFromCloudAndGetCount chiamato senza un utente loggato.',
      );
      throw Exception('Nessun utente loggato per il ripristino.');
    }

    debugPrint('[SyncService] Inizio ripristino per utente ${user.uid}...');

    final querySnapshot = await _userPurchasesCollection().get();

    debugPrint(
      '[SyncService] Query Firestore completata. Trovati ${querySnapshot.docs.length} documenti nel cloud.',
    );

    final cloudPurchases = querySnapshot.docs
        .map((doc) => PurchaseModel.fromJson(doc.data()))
        .toList();

    final box = await Hive.openBox<PurchaseModel>('purchases_${user.uid}');
    await box.clear();
    await box.putAll({for (var p in cloudPurchases) p.id: p});

    debugPrint('[Sync] RESTORE completato. Box locale aggiornata.');
    return cloudPurchases.length;
  }
}

// --- PROVIDERS ---
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider(
  (ref) => FirebaseAuth.instance,
); // Potresti averne già uno

// Provider Sincrono. Le sue dipendenze (firestore, auth) sono disponibili immediatamente.
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref.watch(firestoreProvider), ref.watch(authProvider));
});
