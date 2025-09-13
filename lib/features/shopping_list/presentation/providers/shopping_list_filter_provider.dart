// lib/features/shopping_list/presentation/providers/shopping_list_filter_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_providers.dart';

// Provider per la query di ricerca
final shoppingListSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider che applica il filtro alla lista completa
final filteredShoppingListsProvider = Provider<List<ShoppingListModel>>((ref) {
  final allLists = ref.watch(shoppingListsProvider).valueOrNull ?? [];
  final query = ref.watch(shoppingListSearchQueryProvider).toLowerCase().trim();

  if (query.isEmpty) {
    return allLists;
  }

  return allLists.where((list) {
    final nameMatch = list.name.toLowerCase().contains(query);
    // Cerca anche negli item della lista!
    final itemMatch = list.items.any(
      (item) => item.name.toLowerCase().contains(query),
    );
    return nameMatch || itemMatch;
  }).toList();
});
