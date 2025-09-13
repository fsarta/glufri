// lib/features/shopping_list/presentation/providers/shopping_list_filter_provider.dart

import 'dart:async'; // <-- Import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_providers.dart';

// --- Trasforma in StateNotifier ---
class ShoppingListSearchNotifier extends StateNotifier<String> {
  Timer? _debounce;
  ShoppingListSearchNotifier() : super('');

  void setSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      state = query;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final shoppingListSearchNotifierProvider =
    StateNotifierProvider<ShoppingListSearchNotifier, String>((ref) {
      return ShoppingListSearchNotifier();
    });

// Il provider filtrato ascolta il nuovo notifier
final filteredShoppingListsProvider = Provider<List<ShoppingListModel>>((ref) {
  final allLists = ref.watch(shoppingListsProvider).valueOrNull ?? [];
  final query = ref
      .watch(shoppingListSearchNotifierProvider)
      .toLowerCase()
      .trim();

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
