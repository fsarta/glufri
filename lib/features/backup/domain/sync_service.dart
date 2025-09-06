// lib/features/backup/domain/sync_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
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
  Future<void> restoreFromCloud() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Nessun utente loggato per il ripristino.');
    }

    debugPrint('Inizio ripristino per utente ${user.uid}...');

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
    // Svuota la box locale prima di popolarla (strategia "sostituisci")
    await box.clear();

    // Inserisci tutti i dati scaricati in un'unica operazione
    await box.putAll({for (var p in cloudPurchases) p.id: p});
    debugPrint(
      'Ripristino completato. La box locale ora ha ${box.length} elementi.',
    );
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
