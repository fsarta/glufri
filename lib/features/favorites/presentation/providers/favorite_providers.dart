// lib/features/favorites/presentation/providers/favorite_providers.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Provider Asincrono per il box Hive dei preferiti.
/// Si occupa di APRIRE il box corretto (ospite o utente loggato).
/// I widget e altri provider che dipendono da questo dovranno gestire lo stato di caricamento.
final favoriteBoxProvider = FutureProvider<Box<FavoriteProductModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  final userId = user?.uid ?? localUserId; // 'local' è l'ID per l'utente ospite
  final boxName = 'favorites_$userId';

  // Se il box è già stato aperto in precedenza, Hive lo restituisce immediatamente.
  // Se non è aperto, questa chiamata `await` lo aprirà e solo dopo continuerà l'esecuzione.
  return await Hive.openBox<FavoriteProductModel>(boxName);
});

/// Fornisce una LISTA di preferiti in tempo reale, reagendo ai cambiamenti.
final favoriteListProvider = StreamProvider<List<FavoriteProductModel>>((ref) {
  // `watch` qui osserva `favoriteBoxProvider`. Quando il Future si completa,
  // questo `StreamProvider` si rieseguirà con l'AsyncValue contenente il box.
  final boxAsyncValue = ref.watch(favoriteBoxProvider);

  // `when` è il modo pulito per gestire i diversi stati di un AsyncValue.
  return boxAsyncValue.when(
    loading: () =>
        Stream.value([]), // Mentre il box si apre, emetti una lista vuota.
    error: (err, stack) =>
        Stream.error(err, stack), // In caso di errore, propaga l'errore.
    data: (box) {
      // Quando il box è pronto (`data` contiene il Box<...>), creiamo lo stream vero e proprio.
      final controller = StreamController<List<FavoriteProductModel>>();

      void emitCurrentFavorites() {
        if (controller.isClosed) return;
        final favorites = box.values.toList();
        favorites.sort((a, b) => a.name.compareTo(b.name));
        controller.add(favorites);
      }

      emitCurrentFavorites();

      final subscription = box.watch().listen((_) => emitCurrentFavorites());

      ref.onDispose(() {
        subscription.cancel();
        controller.close();
      });

      return controller.stream;
    },
  );
});

/// Un provider Sincrono che fornisce la classe `FavoriteActions`.
/// Questo provider può essere letto solo quando si è SICURI che i box siano pronti,
/// ad esempio in un `onPressed` di un pulsante in una UI che è già stata costruita
/// usando i dati di `favoriteListProvider` (e quindi i box sono aperti).
final favoriteActionsProvider = Provider((ref) {
  // `requireValue` è un modo comodo per ottenere il valore da un AsyncValue.
  // Lancerà un'eccezione se il Future è ancora in caricamento o in errore,
  // ma come detto sopra, lo useremo in contesti dove il caricamento è già terminato.
  final box = ref.watch(favoriteBoxProvider).requireValue;
  // Prendi le istanze di Firestore e Auth
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(authProvider);
  return FavoriteActions(box, firestore, auth);
});

/// Classe che incapsula le operazioni di scrittura (Aggiungi, Rimuovi) sui preferiti.
class FavoriteActions {
  final Box<FavoriteProductModel> _box;
  // 3. Aggiungi le dipendenze
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  FavoriteActions(this._box, this._firestore, this._auth);

  // Helper per accedere alla collezione remota
  CollectionReference? _remoteCollection() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid).collection('favorites');
  }

  // 4. Modifica i metodi di scrittura
  Future<void> addFavorite(FavoriteProductModel product) async {
    // 4.1 Scrivi prima in locale (come prima)
    await _box.put(product.id, product);

    // 4.2 Poi, prova a scrivere sul cloud
    try {
      final remote = _remoteCollection();
      if (remote != null) {
        await remote.doc(product.id).set(product.toJson());
        debugPrint(
          "[Sync Fav] Preferito '${product.name}' salvato anche su Firestore.",
        );
      }
    } catch (e) {
      debugPrint(
        "[Sync Fav] Errore sync (add) su cloud (probabilmente offline): $e",
      );
    }
  }

  Future<void> removeFavorite(String productId) async {
    // 4.1 Rimuovi prima da locale
    await _box.delete(productId);

    // 4.2 Poi, prova a rimuovere dal cloud
    try {
      final remote = _remoteCollection();
      if (remote != null) {
        await remote.doc(productId).delete();
        debugPrint(
          "[Sync Fav] Preferito ID:$productId rimosso anche da Firestore.",
        );
      }
    } catch (e) {
      debugPrint(
        "[Sync Fav] Errore sync (delete) su cloud (probabilmente offline): $e",
      );
    }
  }

  Future<void> addFavoriteFromItem(PurchaseItemModel item) async {
    final newFavorite = FavoriteProductModel(
      id: const Uuid().v4(),
      name: item.name,
      barcode: item.barcode,
      isGlutenFree: item.isGlutenFree,
      defaultPrice: item.unitPrice,
    );
    await addFavorite(newFavorite);
  }
}
