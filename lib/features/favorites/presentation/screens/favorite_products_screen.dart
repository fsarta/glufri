//lib/features/favorites/presentation/screens/favorite_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/favorites/presentation/providers/favorite_providers.dart';

class FavoriteProductsScreen extends ConsumerWidget {
  const FavoriteProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prodotti Preferiti'), // TODO: Localizza
        actions: [
          // In futuro, qui potrebbe esserci un pulsante "+" per aggiungere manualmente
        ],
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) =>
            Center(child: Text("Errore: $err")), // TODO: Localizza
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                "Non hai ancora prodotti preferiti.\nSalvali da un acquisto.",
              ), // TODO: Localizza
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
                        "Ultimo prezzo: ${product.defaultPrice!.toStringAsFixed(2)} €",
                      ) // TODO: Localizza
                    : null,
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    ref
                        .read(favoriteActionsProvider)
                        .removeFavorite(product.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
