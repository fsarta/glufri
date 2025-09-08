//lib/features/favorites/presentation/screens/favorite_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/core/widgets/skeletons/shimmer_list.dart';
import 'package:glufri/core/widgets/skeletons/skeleton_card.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:glufri/features/favorites/presentation/widgets/add_edit_favorite_dialog.dart';
import 'package:glufri/features/scanner/presentation/screens/barcode_scanner_screen.dart';
import 'package:uuid/uuid.dart';

class FavoriteProductsScreen extends ConsumerWidget {
  const FavoriteProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsFavProducts),
        actions: [
          IconButton(
            tooltip: l10n.scanBarcode,
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final barcode = await Navigator.of(context).push<String>(
                MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
              );

              if (barcode != null && barcode.isNotEmpty && context.mounted) {
                // TODO: in futuro potremmo cercare il nome del prodotto online
                final newProduct = FavoriteProductModel(
                  id: const Uuid().v4(),
                  name: '',
                  barcode: barcode,
                );
                showAddEditFavoriteDialog(context, product: newProduct);
              }
            },
          ),
        ],
      ),
      body: favoritesAsync.when(
        loading: () =>
            const ShimmerList(skeletonCard: ListTileSkeleton(), length: 7),
        error: (err, st) => Center(child: Text(l10n.genericError(err))),
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Text(
                l10n.noFavoriteProducts, // <-- Usa una nuova chiave
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return ListTile(
                leading: Icon(
                  product.isGlutenFree ? Icons.verified : Icons.label,
                  color: product.isGlutenFree ? Colors.green : Colors.grey,
                ),
                title: Text(product.name),
                subtitle: product.defaultPrice != null
                    ? Text(
                        "${l10n.lastPrice} ${product.defaultPrice!.toStringAsFixed(2)} €",
                      )
                    : null,
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    // Invece di cancellare subito, mostra un dialogo di conferma
                    showDialog(
                      context: context,
                      builder: (dCtx) => AlertDialog(
                        title: Text(l10n.deleteConfirmationTitle),
                        content: Text(
                          // Usa una nuova chiave di localizzazione
                          l10n.deleteFavoriteConfirmationBody(product.name),
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
                              // La cancellazione avviene solo dopo la conferma
                              ref
                                  .read(favoriteActionsProvider)
                                  .removeFavorite(product.id);
                              Navigator.of(dCtx).pop();
                            },
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onTap: () {
                  showAddEditFavoriteDialog(context, product: product);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Aggiungi Preferito", // TODO: Localizza
        child: const Icon(Icons.add),
        onPressed: () {
          showAddEditFavoriteDialog(context);
        },
      ),
    );
  }
}
