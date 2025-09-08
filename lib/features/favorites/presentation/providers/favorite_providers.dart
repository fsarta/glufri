// lib/features/favorites/presentation/providers/favorite_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Provider per la box Hive dei preferiti.
final favoriteBoxProvider = Provider(
  (_) => Hive.box<FavoriteProductModel>('favorites'),
);

/// Provider che fornisce una lista di tutti i prodotti preferiti,
/// e si aggiorna automaticamente quando la box cambia.
final favoriteListProvider = StreamProvider<List<FavoriteProductModel>>((ref) {
  final box = ref.watch(favoriteBoxProvider);
  // `watch()` sulla box restituisce uno Stream che emette un nuovo evento
  // ogni volta che i dati nella box cambiano.
  return box.watch().map((event) {
    final favorites = box.values.toList();
    // Ordina i preferiti alfabeticamente per nome
    favorites.sort((a, b) => a.name.compareTo(b.name));
    return favorites;
  });
});

/// Un controller/notifier per le azioni sui preferiti (Aggiungi, Rimuovi).
final favoriteActionsProvider = Provider((ref) {
  final box = ref.watch(favoriteBoxProvider);
  return FavoriteActions(box);
});

class FavoriteActions {
  final Box<FavoriteProductModel> _box;
  FavoriteActions(this._box);

  Future<void> addFavorite(FavoriteProductModel product) async {
    await _box.put(product.id, product);
  }

  Future<void> removeFavorite(String productId) async {
    await _box.delete(productId);
  }

  // Aggiunge un prodotto preferito a partire da un `PurchaseItemModel`
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
