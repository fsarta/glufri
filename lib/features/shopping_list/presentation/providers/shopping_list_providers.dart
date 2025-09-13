// lib/features/shopping_list/presentation/providers/shopping_list_providers.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_item_model.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

// --- PROVIDER DEI BOX ASINCRONI ---

final shoppingListBoxProvider = FutureProvider<Box<ShoppingListModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  final userId = user?.uid ?? localUserId;
  return await Hive.openBox<ShoppingListModel>('shopping_lists_$userId');
});

final shoppingListItemBoxProvider = FutureProvider<Box<ShoppingListItemModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  final userId = user?.uid ?? localUserId;
  return await Hive.openBox<ShoppingListItemModel>(
    'shopping_list_items_$userId',
  );
});

// --- PROVIDER DI LETTURA DEI DATI ---

final shoppingListsProvider = StreamProvider<List<ShoppingListModel>>((ref) {
  final boxAsync = ref.watch(shoppingListBoxProvider);

  return boxAsync.when(
    loading: () => Stream.value([]),
    error: (err, stack) => Stream.error(err, stack),
    data: (box) {
      final controller = StreamController<List<ShoppingListModel>>();
      void emitCurrentLists() {
        if (controller.isClosed) return;
        final lists = box.values.toList();
        lists.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
        controller.add(lists);
      }

      emitCurrentLists();
      final subscription = box.watch().listen((_) => emitCurrentLists());
      ref.onDispose(() {
        subscription.cancel();
        controller.close();
      });
      return controller.stream;
    },
  );
});
// Fornisce una SINGOLA lista della spesa. Si aggiorna automaticamente.
final singleShoppingListProvider = StreamProvider.autoDispose
    .family<ShoppingListModel?, String>((ref, listId) {
      // Questo provider ora dipende da due FutureProvider. Deve gestirlo.
      final listBusAsync = ref.watch(shoppingListBoxProvider);
      final itemBoxAsync = ref.watch(shoppingListItemBoxProvider);

      // Se anche solo uno dei due box è in caricamento, non possiamo procedere.
      if (listBusAsync.isLoading || itemBoxAsync.isLoading) {
        return Stream.value(null); // Emetti null mentre i box si aprono.
      }

      // Se uno dei due box ha un errore, propaghiamo l'errore.
      if (listBusAsync.hasError) return Stream.error(listBusAsync.error!);
      if (itemBoxAsync.hasError) return Stream.error(itemBoxAsync.error!);

      // A questo punto, siamo sicuri che i box siano pronti (`data`).
      final listBox = listBusAsync.value!;
      final itemBox = itemBoxAsync.value!;

      final controller = StreamController<ShoppingListModel?>();
      void emitCurrentData() {
        if (controller.isClosed) return;
        controller.add(listBox.get(listId));
      }

      emitCurrentData();

      final listSubscription = listBox
          .watch(key: listId)
          .listen((_) => emitCurrentData());
      final itemsSubscription = itemBox.watch().listen(
        (_) => emitCurrentData(),
      );

      ref.onDispose(() {
        listSubscription.cancel();
        itemsSubscription.cancel();
        controller.close();
      });

      return controller.stream;
    });

// --- PROVIDER DI SCRITTURA (AZIONI) ---

final shoppingListActionsProvider = Provider((ref) {
  // Leggiamo i box come prima
  final listBox = ref.watch(shoppingListBoxProvider).requireValue;
  final itemBox = ref.watch(shoppingListItemBoxProvider).requireValue;

  // Aggiungiamo le dipendenze per Firestore
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(authProvider);

  return ShoppingListActions(listBox, itemBox, firestore, auth);
});

class ShoppingListActions {
  final Box<ShoppingListModel> _listBox;
  final Box<ShoppingListItemModel> _itemBox;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ShoppingListActions(
    this._listBox,
    this._itemBox,
    this._firestore,
    this._auth,
  );

  /// Helper per ottenere il riferimento alla collezione remota delle liste
  CollectionReference? _remoteListsCollection() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('shopping_lists');
  }

  // AZIONI SULLA LISTA
  Future<String> createNewList(String name) async {
    final newList = ShoppingListModel(
      id: const Uuid().v4(),
      name: name,
      dateCreated: DateTime.now(),
      // Inizializza con un HiveList vuoto che punta alla box degli item
      items: HiveList(_itemBox),
    );
    await _listBox.put(newList.id, newList);
    debugPrint("[Sync List] Nuova lista '${newList.name}' salvata in Hive.");

    // 2. Prova a salvare in cloud
    try {
      final remote = _remoteListsCollection();
      if (remote != null) {
        await remote.doc(newList.id).set(newList.toJson());
        debugPrint("[Sync List] Nuova lista salvata anche su Firestore.");
      }
    } catch (e) {
      debugPrint(
        "[Sync List] Errore sync (create list) su cloud (probabilmente offline): $e",
      );
    }
    return newList.id;
  }

  Future<void> deleteList(ShoppingListModel list) async {
    final listId = list.id;
    // Prima si cancellano gli item dalla loro box, poi la lista.
    // list.items.deleteAll(keys) non è un metodo valido. Facciamo in loop.
    final itemsToDeleteKeys = list.items
        .map((item) => item.key as dynamic)
        .toList();
    await _itemBox.deleteAll(itemsToDeleteKeys);
    // Ora cancella la lista principale
    await _listBox.delete(list.id);

    debugPrint("[Sync List] Lista '$listId' e i suoi item cancellati da Hive.");

    // Prova a cancellare anche dal cloud
    try {
      final remote = _remoteListsCollection();
      if (remote != null) {
        // In Firestore, cancellando il documento della lista si cancellano anche i dati degli item
        // contenuti nel suo array 'items', quindi non servono cancellazioni multiple.
        await remote.doc(listId).delete();
        debugPrint(
          "[Sync List] Lista '$listId' cancellata anche da Firestore.",
        );
      }
    } catch (e) {
      debugPrint(
        "[Sync List] Errore sync (delete list) su cloud (probabilmente offline): $e",
      );
    }
  }

  /// Helper DRY per aggiornare una lista su Firestore
  Future<void> _updateRemoteList(ShoppingListModel list) async {
    try {
      final remote = _remoteListsCollection();
      if (remote != null) {
        await remote.doc(list.id).set(list.toJson());
        debugPrint("[Sync List] Lista '${list.id}' aggiornata su Firestore.");
      }
    } catch (e) {
      debugPrint(
        "[Sync List] Errore sync (update list item) su cloud (probabilmente offline): $e",
      );
    }
  }

  // AZIONI SUGLI ITEM

  Future<void> addItemToList(
    ShoppingListModel list,
    String name,
    bool isGlutenFree,
  ) async {
    final newItem = ShoppingListItemModel(
      id: const Uuid().v4(),
      name: name,
      isGlutenFree: isGlutenFree,
    );
    await _itemBox.add(newItem);
    list.items.add(newItem);
    await list.save(); // Fondamentale per Hive
    debugPrint("[Sync List] Item '${newItem.name}' aggiunto a Hive.");

    // Aggiorna l'intera lista su Firestore
    await _updateRemoteList(list);
  }

  Future<void> addFavoriteToList(
    ShoppingListModel list,
    FavoriteProductModel fav,
  ) async {
    final newItem = ShoppingListItemModel(
      id: const Uuid().v4(),
      name: fav.name,
      isGlutenFree: fav.isGlutenFree,
    );
    await _itemBox.add(newItem);
    list.items.add(newItem);
    await list.save();
    debugPrint(
      "[Sync List] Preferito '${newItem.name}' aggiunto alla lista su Hive.",
    );

    // Aggiorna l'intera lista su Firestore
    await _updateRemoteList(list);
  }

  Future<void> updateItemInList(
    ShoppingListModel list,
    ShoppingListItemModel item,
  ) async {
    // Le modifiche all'item (come cambiare isChecked) vengono fatte PRIMA di chiamare questo metodo.
    // Qui dobbiamo solo salvare.
    await item.save(); // Salva le modifiche all'oggetto item in Hive.
    await list
        .save(); // Salva la lista genitore (anche se non strettamente necessario, è una buona pratica).
    debugPrint("[Sync List] Item '${item.name}' aggiornato in Hive.");
    await _updateRemoteList(list); // Aggiorna l'intera lista su Firestore.
  }

  Future<void> deleteItemFromList(
    ShoppingListModel list,
    ShoppingListItemModel item,
  ) async {
    await item.delete(); // Questo lo rimuove da itemBox E da list.items
    await list.save(); // Salva lo stato della lista senza l'item
    debugPrint("[Sync List] Item '${item.name}' cancellato da Hive.");

    // Aggiorna l'intera lista su Firestore
    await _updateRemoteList(list);
  }
}
