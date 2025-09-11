import 'package:flutter/material.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_remote_datasource.dart';

import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_local_datasource.dart';
import '../models/purchase_model.dart';

// L'implementazione concreta che usa il datasource
class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseLocalDataSource localDataSource;
  final PurchaseRemoteDataSource remoteDataSource;

  PurchaseRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<void> addPurchase(PurchaseModel purchase) async {
    // 1. Scrivi prima in locale per una risposta immediata della UI
    await localDataSource.addPurchase(purchase);

    // 2. Poi, prova a scrivere sul cloud in background.
    // Usiamo un try-catch: se l'utente è offline, la scrittura locale
    // ha successo comunque e l'app non si blocca.
    try {
      await remoteDataSource.savePurchase(purchase);
    } catch (e) {
      debugPrint('Errore sync (add) su cloud (probabilmente offline): $e');
    }
  }

  @override
  Future<void> updatePurchase(PurchaseModel purchase) async {
    // Stessa logica: prima locale, poi remoto
    await localDataSource.updatePurchase(purchase);
    try {
      await remoteDataSource.savePurchase(purchase);
    } catch (e) {
      debugPrint('Errore sync (update) su cloud (probabilmente offline): $e');
    }
  }

  @override
  Future<void> deletePurchase(String purchaseId) async {
    // Stessa logica: prima locale, poi remoto
    await localDataSource.deletePurchase(purchaseId);
    try {
      await remoteDataSource.deletePurchase(purchaseId);
    } catch (e) {
      debugPrint('Errore sync (delete) su cloud (probabilmente offline): $e');
    }
  }

  @override
  Future<List<PurchaseModel>> getPurchases() {
    // Per le letture, ci affidiamo SEMPRE alla fonte locale (Hive),
    // che è veloce e funziona offline. Sarà compito del SyncService
    // al login assicurarsi che i dati locali siano aggiornati.
    return localDataSource.getPurchases();
  }
}
