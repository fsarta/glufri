//lib/features/favorites/presentation/screens/favorite_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
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
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 80,
            ), // Padding per il FAB
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];

              return Slidable(
                // Chiave univoca, come prima
                key: ValueKey(product.id),

                // --- 2. DEFINIAMO IL PANNELLO DELLE AZIONI A DESTRA (endActionPane) ---
                endActionPane: ActionPane(
                  // `motion` definisce l'animazione. `StretchMotion` è un bell'effetto elastico.
                  motion: const StretchMotion(),
                  // `children` è la lista dei pulsanti di azione che vogliamo mostrare.
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // Rimuovi il dialogo e chiama direttamente l'azione di eliminazione.
                        ref
                            .read(favoriteActionsProvider)
                            .removeFavorite(product.id);
                        // Mostra una SnackBar per conferma (e futuro 'Annulla')
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.favoriteProductRemoved(product.name),
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color(
                        0xFFFE4A49,
                      ), // Un rosso standard per l'eliminazione
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: l10n.delete,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),

                // --- 3. IL NOSTRO LISTTILE È ORA IL 'child' DI SLIDABLE ---
                child: ListTile(
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
                  // NON abbiamo più bisogno del trailing: IconButton. La UI è più pulita.
                  // L'unica azione ora è lo swipe.

                  // L'onTap rimane per la MODIFICA
                  onTap: () {
                    showAddEditFavoriteDialog(context, product: product);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'favorite_products_fab',
        tooltip: l10n.addFavoriteProduct,
        child: const Icon(Icons.add),
        onPressed: () {
          showAddEditFavoriteDialog(context);
        },
      ),
    );
  }
}
