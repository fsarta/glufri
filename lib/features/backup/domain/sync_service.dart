// lib/features/backup/domain/sync_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:hive/hive.dart';

class SyncService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SyncService(this._firestore, this._auth);

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
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .doc(purchase.id);
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

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('purchases')
        .get();

    debugPrint(
      '[SyncService] Query Firestore completata. Trovati ${querySnapshot.docs.length} documenti nel cloud.',
    );

    final cloudPurchases = querySnapshot.docs
        .map((doc) {
          // Aggiungiamo un try-catch qui per scovare problemi di deserializzazione
          try {
            return PurchaseModel.fromJson(doc.data());
          } catch (e) {
            debugPrint(
              '[SyncService] ERRORE durante la conversione di un documento da Firestore: $e',
            );
            return null;
          }
        })
        .whereType<PurchaseModel>()
        .toList();

    if (cloudPurchases.isNotEmpty) {
      final box = await Hive.openBox<PurchaseModel>('purchases_${user.uid}');
      debugPrint('[SyncService] Box Hive "purchases_${user.uid}" aperta.');
      await box.clear();
      await box.putAll({for (var p in cloudPurchases) p.id: p});
      debugPrint(
        '[SyncService] Box Hive svuotata e ripopolata con ${cloudPurchases.length} acquisti.',
      );
    } else {
      debugPrint('[SyncService] Nessun acquisto valido da salvare in Hive.');
    }

    debugPrint(
      '[SyncService] Ripristino terminato. Restituisco il conteggio: ${cloudPurchases.length}',
    );
    return cloudPurchases.length;
  }
}

// --- PROVIDERS ---
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider(
  (ref) => FirebaseAuth.instance,
); // Potresti averne già uno

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref.watch(firestoreProvider), ref.watch(authProvider));
});
