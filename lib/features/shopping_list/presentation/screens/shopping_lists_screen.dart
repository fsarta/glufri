// lib/features/shopping_list/presentation/screens/shopping_lists_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_filter_provider.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_providers.dart';
import 'package:glufri/features/shopping_list/presentation/screens/shopping_list_detail_screen.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Osserviamo i provider necessari:
    // - `filteredShoppingListsProvider` per ottenere la lista già filtrata.
    // - `shoppingListSearchQueryProvider` per gestire la UI della barra di ricerca (es. la "X").
    final lists = ref.watch(filteredShoppingListsProvider);
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(shoppingListSearchNotifierProvider);

    // Usiamo `allListsAsync` solo per controllare lo stato di caricamento/errore iniziale.
    final allListsAsync = ref.watch(shoppingListsProvider);

    return Scaffold(
      appBar: AppBar(
        // Il drawer se lo hai aggiunto
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(l10n.shoppingListsScreenTitle),
      ),
      // 3. La struttura del body diventa una Colonna per ospitare la barra di ricerca in alto
      //    e la lista che occupa lo spazio rimanente.
      body: Column(
        children: [
          // --- BARRA DI RICERCA ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              // Usiamo un controller "usa e getta" per posizionare il cursore alla fine del testo.
              controller: TextEditingController(text: query),
              onChanged: (value) => ref
                  .read(shoppingListSearchNotifierProvider.notifier)
                  .setSearchQuery(value),

              decoration: InputDecoration(
                hintText: "Cerca per lista o prodotto...", // TODO: Localizza
                prefixIcon: const Icon(Icons.search),
                // Logica per mostrare la "X" di cancellazione
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => ref
                            .read(shoppingListSearchNotifierProvider.notifier)
                            .setSearchQuery(''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // --- LISTA DELLE LISTE ---
          // `Expanded` assicura che il contenuto della lista occupi tutto lo spazio verticale rimanente.
          Expanded(
            child: allListsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text(l10n.shoppingListError)),
              data: (allLists) {
                // Una volta che i dati sono caricati, usiamo la lista GIA' FILTRATA (`lists`).
                if (allLists.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.emptyShoppingList,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (lists.isEmpty && query.isNotEmpty) {
                  return const Center(
                    child: Text("Nessuna lista trovata per la tua ricerca."),
                  ); // TODO: Localizza
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lists.length,
                  itemBuilder: (ctx, index) {
                    final list = lists[index];
                    final totalItems = list.items.length;
                    final checkedItems = list.items
                        .where((i) => i.isChecked)
                        .length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          list.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          l10n.checkedItems(
                            checkedItems.toString(),
                            totalItems.toString(),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          child: Text("${totalItems - checkedItems}"),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => _showDeleteConfirmationDialog(
                            context,
                            ref,
                            list,
                            l10n,
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ShoppingListDetailScreen(listId: list.id),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'shopping_lists_fab',
        icon: const Icon(Icons.add),
        label: Text(l10n.createNewListTooltip),
        onPressed: () => _showCreateListDialog(context, ref, l10n),
      ),
    );
  }

  // --- WIDGET HELPER SPOSTATI FUORI DAL BUILD ---

  // Dialogo per la creazione di una nuova lista
  void _showCreateListDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.createListDialogTitle),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: l10n.listName),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.listNameEmptyError;
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            Consumer(
              builder: (context, ref, child) {
                // Osserviamo ENTRAMBI i future provider. `isLoading` sarà true se anche solo uno sta caricando.
                final bool isLoading =
                    ref.watch(shoppingListBoxProvider).isLoading ||
                    ref.watch(shoppingListItemBoxProvider).isLoading;

                return FilledButton(
                  // Disabilitiamo il pulsante mentre i box si aprono
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            final newListName = controller.text.trim();
                            try {
                              // A questo punto siamo SICURI che i provider abbiano un valore.
                              final actions = ref.read(
                                shoppingListActionsProvider,
                              );
                              await actions.createNewList(newListName);

                              // Chiudi il dialogo solo dopo il successo
                              if (ctx.mounted) Navigator.of(ctx).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Lista '$newListName' creata!"),
                                ), // TODO
                              );
                            } catch (e, stack) {
                              debugPrint(
                                "Errore durante la creazione della lista: $e\n$stack",
                              );
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Errore: impossibile creare la lista. Riprova.",
                                  ),
                                ),
                              ); // TODO
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.create),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Dialogo di conferma per l'eliminazione
  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    ShoppingListModel list,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: Text(l10n.deleteListConfirmationTitle),
        content: Text(l10n.deleteListConfirmationBody(list.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dCtx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              ref.read(shoppingListActionsProvider).deleteList(list);
              Navigator.of(dCtx).pop();
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
