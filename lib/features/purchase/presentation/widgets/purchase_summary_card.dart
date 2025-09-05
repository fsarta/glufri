// lib/features/purchase/presentation/widgets/purchase_summary_card.dart

import 'package:flutter/material.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:intl/intl.dart';

class PurchaseSummaryCard extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseSummaryCard({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              Text(
                l10n.appName,
                style: const TextStyle(
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
            purchase.store ?? l10n.genericPurchase,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat.yMMMMEEEEd().format(
              purchase.date,
            ), // ATTENZIONE era 'it_IT'
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.mainProducts,
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
            Text(l10n.andMoreProducts(purchase.items.length - 3)),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              l10n.trackedWith,
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
