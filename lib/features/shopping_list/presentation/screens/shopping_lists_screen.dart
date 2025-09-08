import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_providers.dart';
import 'package:glufri/features/shopping_list/presentation/screens/shopping_list_detail_screen.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(shoppingListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste della Spesa"), // TODO: Localizza
      ),
      body: listsAsync.when(
        data: (lists) {
          if (lists.isEmpty) {
            return const Center(
              child: Text(
                "Nessuna lista della spesa.\nPremi '+' per crearne una.", // TODO: Localizza
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: lists.length,
            itemBuilder: (ctx, index) {
              final list = lists[index];
              final totalItems = list.items.length;
              final checkedItems = list.items.where((i) => i.isChecked).length;

              return Card(
                child: ListTile(
                  title: Text(
                    list.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$checkedItems / $totalItems completati',
                  ), // TODO: Localizza
                  leading: CircularProgressIndicator(
                    value: totalItems > 0 ? (checkedItems / totalItems) : 0,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () {
                      // Dialog di conferma per sicurezza
                      showDialog(
                        context: context,
                        builder: (dCtx) => AlertDialog(
                          title: const Text(
                            "Conferma Eliminazione",
                          ), //TODO: Localizza
                          content: Text(
                            "Sei sicuro di voler eliminare la lista '${list.name}'?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dCtx).pop(),
                              child: const Text("Annulla"),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                              onPressed: () {
                                ref
                                    .read(shoppingListActionsProvider)
                                    .deleteList(list);
                                Navigator.of(dCtx).pop();
                              },
                              child: const Text("Elimina"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ShoppingListDetailScreen(listId: list.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) =>
            const Center(child: Text("Errore nel caricamento delle liste.")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Nuova Lista"),
        onPressed: () => _showCreateListDialog(context, ref),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Crea Nuova Lista"),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Nome della lista"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Il nome non può essere vuoto.";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Annulla"),
            ),
            FilledButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await ref
                      .read(shoppingListActionsProvider)
                      .createNewList(controller.text.trim());
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text("Crea"),
            ),
          ],
        );
      },
    );
  }
}
