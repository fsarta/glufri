import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_session_screen.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_item_model.dart';
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
              return _ShoppingListItemTile(
                // La chiave è ora sul nostro nuovo widget, come prima.
                key: ValueKey(item.id),
                item: item,
                list: list,
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
    final favorites = await ref.read(favoriteListProvider.future);
    final list = ref.read(singleShoppingListProvider(listId)).value;
    if (list == null || !context.mounted) return;

    if (favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Non hai prodotti preferiti.")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      // Bordi arrotondati e altezza controllata per un look moderno
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        // Usiamo DraggableScrollableSheet per un controllo migliore sullo scroll
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Inizia al 60% dell'altezza
          minChildSize: 0.3, // Può essere ridotto al 30%
          maxChildSize: 0.9, // Può essere esteso al 90%
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
                // "Maniglia" per indicare che il foglio è trascinabile
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Titolo del BottomSheet
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Seleziona un Preferito", // TODO: Localizza
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                // La nostra nuova griglia
                Expanded(
                  child: GridView.builder(
                    controller:
                        scrollController, // Usa il controller del DraggableSheet
                    padding: const EdgeInsets.all(12),
                    // Quante colonne mostrare
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 colonne in verticale
                          crossAxisSpacing: 10, // Spazio orizzontale
                          mainAxisSpacing: 10, // Spazio verticale
                          childAspectRatio:
                              0.9, // Rapporto larghezza/altezza delle card
                        ),
                    itemCount: favorites.length,
                    itemBuilder: (ctx, index) {
                      final fav = favorites[index];
                      // Usiamo un widget card dedicato
                      return _FavoriteProductCard(
                        product: fav,
                        onTap: () {
                          ref
                              .read(shoppingListActionsProvider)
                              .addFavoriteToList(list, fav);
                          // Aggiungiamo un feedback visivo rapido
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "'${fav.name}' aggiunto alla lista.",
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          // Non chiudiamo il BottomSheet, così l'utente può aggiungere più item
                          // Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ShoppingListItemTile extends ConsumerWidget {
  const _ShoppingListItemTile({
    super.key, // Riceve la key
    required this.item,
    required this.list,
  });

  final ShoppingListItemModel item;
  final ShoppingListModel list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Il widget si costruisce con i dati dell'item che gli vengono passati.

    return Dismissible(
      key: key!, // Usa la key passata dal costruttore
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(shoppingListActionsProvider).deleteItemFromList(list, item);
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
        onChanged: (newValue) {
          // Quando si interagisce con il checkbox, si chiama l'azione
          // che aggiornerà lo stato in Hive. Riverpod farà ricostruire
          // questo specifico widget con il nuovo stato `item.isChecked`.
          ref.read(shoppingListActionsProvider).toggleItemChecked(item);
        },
        // Aggiungi un colore più visibile per il check attivo
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  final FavoriteProductModel product;
  final VoidCallback onTap;

  const _FavoriteProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip
          .antiAlias, // Assicura che l'effetto InkWell rimanga dentro i bordi
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icona che indica lo stato (es. SG)
              Icon(
                product.isGlutenFree ? Icons.verified : Icons.label_outline,
                color: product.isGlutenFree
                    ? Colors.green
                    : theme.colorScheme.primary,
                size: 36,
              ),
              const SizedBox(height: 8),
              // Nome del prodotto, centrato e con gestione del testo a capo
              Text(
                product.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow
                    .ellipsis, // Aggiunge "..." se il testo è troppo lungo
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Prezzo di default, se presente
              if (product.defaultPrice != null &&
                  product.defaultPrice! > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${product.defaultPrice!.toStringAsFixed(2)} €',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
