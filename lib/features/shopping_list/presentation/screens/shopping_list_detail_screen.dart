import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_session_screen.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_providers.dart';
import 'package:uuid/uuid.dart';

class ShoppingListDetailScreen extends ConsumerWidget {
  final String listId;
  const ShoppingListDetailScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usiamo il provider corretto, non quello "autoDispose"
    final listAsync = ref.watch(singleShoppingListProvider(listId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          listAsync.value?.name ?? "Caricamento...",
        ), // Titolo dinamico
      ),
      body: listAsync.when(
        data: (list) {
          if (list == null) {
            return const Center(child: Text("Lista non trovata o eliminata."));
          }
          // Ordina gli item: prima quelli non spuntati, poi quelli spuntati
          final sortedItems = List.from(list.items);
          sortedItems.sort((a, b) {
            if (a.isChecked && !b.isChecked) return 1;
            if (!a.isChecked && b.isChecked) return -1;
            return a.name.compareTo(b.name);
          });

          return ListView.builder(
            itemCount: sortedItems.length,
            itemBuilder: (ctx, index) {
              final item = sortedItems[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ref
                      .read(shoppingListActionsProvider)
                      .deleteItemFromList(list, item);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: CheckboxListTile(
                  value: item.isChecked,
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: item.isChecked ? Colors.grey : null,
                    ),
                  ),
                  onChanged: (val) {
                    ref
                        .read(shoppingListActionsProvider)
                        .toggleItemChecked(item);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => const Center(child: Text("Errore")),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Aggiungi item", // TODO: Localizza
        child: const Icon(Icons.add),
        onPressed: () => _showAddItemSourceDialog(context, ref),
      ),
      // Usa persistentFooterButtons per il pulsante "Inizia Acquisto"
      persistentFooterButtons: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text(
                "Inizia Acquisto dalla Lista",
              ), // TODO: Localizza
              onPressed: () {
                final list = ref.read(singleShoppingListProvider(listId)).value;
                if (list == null ||
                    list.items.where((i) => !i.isChecked).isEmpty) {
                  // Mostra un messaggio se la lista è vuota o tutti gli item sono spuntati
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Aggiungi o de-seleziona almeno un item per iniziare.",
                      ),
                    ),
                  );
                  return;
                }

                ref.read(cartProvider.notifier).reset();

                for (final item in list.items.where((i) => !i.isChecked)) {
                  final purchaseItem = PurchaseItemModel(
                    id: const Uuid().v4(),
                    name: item.name,
                    quantity: item.quantity,
                    isGlutenFree: item.isGlutenFree,
                    unitPrice:
                        0.0, // Il prezzo andrà inserito/modificato dall'utente
                  );
                  ref.read(cartProvider.notifier).addItem(purchaseItem);
                }

                // Chiude questa schermata e va a quella di acquisto
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const PurchaseSessionScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Dialogo che chiede se aggiungere da Preferiti o Manualmente
  void _showAddItemSourceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Aggiungi da Preferiti'), // TODO: Localizza
            onTap: () {
              Navigator.of(ctx).pop();
              _showFavoritesPickerForList(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Aggiungi manualmente'), // TODO: Localizza
            onTap: () {
              Navigator.of(ctx).pop();
              final list = ref.read(singleShoppingListProvider(listId)).value;
              if (list != null) {
                // E la passiamo come parametro al dialogo
                _showManualAddItemDialog(context, ref, list);
              }
            },
          ),
        ],
      ),
    );
  }

  // Dialogo per aggiungere un item MANUALE
  void _showManualAddItemDialog(
    BuildContext context,
    WidgetRef ref,
    ShoppingListModel list,
  ) {
    final controller = TextEditingController();
    bool isGlutenFree = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        // Serve per il checkbox
        builder: (dCtx, setState) => AlertDialog(
          title: const Text("Aggiungi Prodotto"), // TODO:
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: "Nome prodotto"),
              ),
              CheckboxListTile(
                title: Text("Senza Glutine"),
                value: isGlutenFree,
                onChanged: (val) => setState(() => isGlutenFree = val ?? false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dCtx).pop(),
              child: Text("Annulla"),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  // --- USA L'OGGETTO 'list' PASSATO COME PARAMETRO ---
                  // Non serve più ref.read qui!
                  ref
                      .read(shoppingListActionsProvider)
                      .addItemToList(
                        list,
                        controller.text.trim(),
                        isGlutenFree,
                      );
                  Navigator.of(dCtx).pop();
                }
              },
              child: const Text("Aggiungi"),
            ),
          ],
        ),
      ),
    );
  }

  // Dialogo che mostra i preferiti
  void _showFavoritesPickerForList(BuildContext context, WidgetRef ref) async {
    // Leggi la lista e i preferiti PRIMA di mostrare il dialogo
    final favorites = await ref.read(favoriteListProvider.future);
    final list = ref.read(singleShoppingListProvider(listId)).value;

    // Controllo di sicurezza
    if (list == null || !context.mounted) return;
    if (favorites.isEmpty) {
      /* mostra snackbar */
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (ctx, index) {
          final fav = favorites[index];
          return ListTile(
            title: Text(fav.name),
            onTap: () {
              // Usa l'oggetto 'list' letto in precedenza
              ref
                  .read(shoppingListActionsProvider)
                  .addFavoriteToList(list, fav);
              Navigator.of(ctx).pop();
            },
          );
        },
      ),
    );
  }
}
