import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_providers.dart';
import 'package:glufri/features/shopping_list/presentation/screens/shopping_list_detail_screen.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(shoppingListsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(l10n.shoppingListsScreenTitle),
      ),
      body: listsAsync.when(
        data: (lists) {
          if (lists.isEmpty) {
            return Center(
              child: Text(l10n.emptyShoppingList, textAlign: TextAlign.center),
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
                          title: Text(l10n.deleteListConfirmationTitle),
                          content: Text(
                            l10n.deleteListConfirmationBody(list.name),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dCtx).pop(),
                              child: Text(l10n.cancel),
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
                              child: Text(l10n.delete),
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
        error: (err, st) => Center(child: Text(l10n.shoppingListError)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'shopping_lists_fab',
        icon: const Icon(Icons.add),
        label: Text(l10n.createNewListTooltip),
        onPressed: () => _showCreateListDialog(context, ref),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
            FilledButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await ref
                      .read(shoppingListActionsProvider)
                      .createNewList(controller.text.trim());
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(l10n.create),
            ),
          ],
        );
      },
    );
  }
}
