import 'package:flutter/material.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:intl/intl.dart';

class PurchaseSummaryCard extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseSummaryCard({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.surface,
      width: 400, // Larghezza fissa per un buon aspect ratio
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Glufri',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green,
                ),
              ),
              Text(
                '${purchase.total.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            purchase.store ?? 'Acquisto generico',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat.yMMMMEEEEd('it_IT').format(purchase.date),
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Text(
            'Prodotti principali:',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          ...purchase.items
              .take(3)
              .map(
                (item) => Text(
                  '• ${item.name}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          if (purchase.items.length > 3)
            Text('... e altri ${purchase.items.length - 3} prodotti.'),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Tracciato con Glufri App',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
