import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_item_model.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

final shoppingListBoxProvider = Provider(
  (ref) => Hive.box<ShoppingListModel>('shopping_lists'),
);
final shoppingListItemBoxProvider = Provider(
  (ref) => Hive.box<ShoppingListItemModel>('shopping_list_items'),
);

final shoppingListsProvider = StreamProvider<List<ShoppingListModel>>((ref) {
  final box = ref.watch(shoppingListBoxProvider);
  return box.watch().map((_) {
    final lists = box.values.toList();
    lists.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return lists;
  });
});

// Fornisce una SINGOLA lista della spesa. Si aggiorna automaticamente.
final singleShoppingListProvider = StreamProvider.autoDispose
    .family<ShoppingListModel?, String>((ref, listId) {
      // Prendiamo le box una sola volta
      final listBox = ref.watch(shoppingListBoxProvider);
      final itemBox = ref.watch(shoppingListItemBoxProvider);

      // 1. Controller per gestire lo Stream manualmente
      final controller = StreamController<ShoppingListModel?>();

      // 2. Funzione per emettere i dati più recenti
      void emitCurrentData() {
        final list = listBox.get(listId);
        // Non è necessario ricaricare gli item, HiveList lo fa in automatico.
        // L'importante è ri-emettere la lista stessa.
        if (!controller.isClosed) {
          controller.add(list);
        }
      }

      // 3. Emetti subito i dati iniziali
      emitCurrentData();

      // 4. Mettiti in ascolto dei cambiamenti in ENTRAMBE le box
      final listSubscription = listBox
          .watch(key: listId)
          .listen((_) => emitCurrentData());
      final itemsSubscription = itemBox.watch().listen(
        (_) => emitCurrentData(),
      );

      // 5. Quando il provider viene distrutto, chiudi tutto per evitare memory leak
      ref.onDispose(() {
        listSubscription.cancel();
        itemsSubscription.cancel();
        controller.close();
      });

      return controller.stream;
    });

class ShoppingListActions {
  final Box<ShoppingListModel> _listBox;
  final Box<ShoppingListItemModel>
  _itemBox; // Box dove vengono salvati TUTTI gli item
  ShoppingListActions(this._listBox, this._itemBox);

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
    return newList.id;
  }

  Future<void> deleteList(ShoppingListModel list) async {
    // Prima si cancellano gli item dalla loro box, poi la lista.
    // list.items.deleteAll(keys) non è un metodo valido. Facciamo in loop.
    final itemsToDeleteKeys = list.items
        .map((item) => item.key as dynamic)
        .toList();
    await _itemBox.deleteAll(itemsToDeleteKeys);

    // Ora cancella la lista principale
    await _listBox.delete(list.id);
  }

  // AZIONI SUGLI ITEM

  // --- LOGICA DI AGGIUNTA CORRETTA ---
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
    // 1. PRIMA salva il nuovo item nella sua box principale.
    await _itemBox.add(newItem);

    // 2. POI aggiungi l'item (che ora è in una box) alla relazione HiveList.
    list.items.add(newItem);

    // 3. Salva la lista che contiene la relazione per persisterla.
    await list.save();
  }

  // --- LOGICA DI AGGIUNTA DA PREFERITI CORRETTA ---
  Future<void> addFavoriteToList(
    ShoppingListModel list,
    FavoriteProductModel fav,
  ) async {
    final newItem = ShoppingListItemModel(
      id: const Uuid().v4(),
      name: fav.name,
      isGlutenFree: fav.isGlutenFree,
    );
    // Stessa logica: prima salva l'item...
    await _itemBox.add(newItem);
    // ...poi aggiungilo alla lista.
    list.items.add(newItem);
    await list.save();
  }

  Future<void> toggleItemChecked(ShoppingListItemModel item) async {
    item.isChecked = !item.isChecked;
    await item.save(); // Salva direttamente l'oggetto item, corretto
  }

  // --- LOGICA DI CANCELLAZIONE DI UN ITEM CORRETTA ---
  Future<void> deleteItemFromList(
    ShoppingListModel list,
    ShoppingListItemModel item,
  ) async {
    // Quando cancelli l'oggetto dalla sua box principale con .delete(),
    // Hive è abbastanza intelligente da rimuovere automaticamente il riferimento
    // anche dalla HiveList. Non serve rimuoverlo manualmente.
    await item.delete();

    // Anche se Hive aggiorna la relazione, a volte salvare il genitore
    // può aiutare a notificare i listener. È una buona pratica.
    await list.save();
  }
}

final shoppingListActionsProvider = Provider((ref) {
  return ShoppingListActions(
    ref.watch(shoppingListBoxProvider),
    ref.watch(shoppingListItemBoxProvider),
  );
});
