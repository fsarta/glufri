import 'package:flutter/material.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:intl/intl.dart';

/// Un widget che rappresenta una card di un acquisto quando i risultati
/// sono filtrati da una query di ricerca.
///
/// Mostra solo gli articoli di quell'acquisto che corrispondono alla query.
class FilteredPurchaseItemCard extends StatelessWidget {
  final PurchaseModel purchase;
  final String searchQuery;

  const FilteredPurchaseItemCard({
    super.key,
    required this.purchase,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Filtra la lista degli items INTERNAMENTE al widget.
    //    Prende solo gli item il cui nome contiene la query di ricerca.
    final filteredItems = purchase.items.where((item) {
      return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Se, per qualche strano motivo, nessun item corrisponde (improbabile
    // data la logica del provider), non mostrare nulla.
    if (filteredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // 2. Costruisci la Card con le informazioni filtrate.
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intestazione con Negozio/Titolo Smart E IL NUOVO TOTALE
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Colonna per Titolo e Data a sinistra
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Usiamo lo smart title anche qui per coerenza
                        purchase.smartTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines:
                            2, // Permette al titolo di andare a capo se lungo
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm:ss').format(purchase.date),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                // Spazio per separare
                const SizedBox(width: 16),
                // Totale dell'acquisto originale, allineato a destra
                Text(
                  '${purchase.total.toStringAsFixed(2)} €',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            /* Text(
              DateFormat.yMMMd().format(purchase.date),
              style: theme.textTheme.bodySmall,
            ), */
            const Divider(height: 20),

            // Lista dei soli prodotti che hanno matchato la ricerca
            Text(
              l10n.foundProducts,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...filteredItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        '• ${item.name}',
                        style: theme.textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)} €',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${item.subtotal.toStringAsFixed(2)} €',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
