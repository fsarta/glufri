import 'package:flutter/material.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:intl/intl.dart';

/// Una card per visualizzare un riepilogo di un acquisto nella cronologia.
/// Usata quando non è attiva nessuna ricerca.
class PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseCard({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Abbiamo rimosso l'InkWell che avvolgeva il Padding.
    // L'evento di tocco sarà gestito dal GestureDetector nella schermata principale.
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Riga superiore con titolo smart e totale acquisto
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    purchase.smartTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${purchase.total.toStringAsFixed(2)} €',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Riga inferiore con data/ora e numero di prodotti
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icona e Data/Ora
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(purchase.date),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                // Icona e Numero Prodotti
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${purchase.items.length} prodotti',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (purchase.totalGlutenFree > 0) ...[
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SummaryChip(
                    label: 'Senza Glutine',
                    total: purchase.totalGlutenFree,
                    icon: Icons.verified,
                    color: Colors.green,
                  ),
                  _SummaryChip(
                    label: 'Altro',
                    total: purchase.totalRegular,
                    icon: Icons.label_outline,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.total,
    required this.icon,
    required this.color,
  });

  final String label;
  final double total;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        Text(
          '${total.toStringAsFixed(2)} €',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
