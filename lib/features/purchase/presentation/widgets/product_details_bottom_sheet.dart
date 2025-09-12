// lib/features/purchase/presentation/widgets/product_details_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/purchase/domain/entities/off_product.dart';

/// Mostra un BottomSheet con i dettagli del prodotto da Open Food Facts.
Future<void> showProductDetailsBottomSheet(
  BuildContext context,
  OffProduct product,
) async {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: [
              // Intestazione con immagine e nome
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood, size: 80),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      product.name ?? l10n.productName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Dettagli (Nutri-Score, NOVA, etc.)
              _buildDetailRow(
                context,
                "Nutri-Score",
                _getNutriScoreWidget(context, product.nutriScore),
              ),
              _buildDetailRow(
                context,
                "Processazione (NOVA)", // TODO: Localizza
                _getNovaGroupWidget(context, product.novaGroup),
              ),

              const SizedBox(height: 16),
              // Ingredienti espandibili
              if (product.ingredients != null &&
                  product.ingredients!.isNotEmpty)
                ExpansionTile(
                  title: const Text("Ingredienti"), // TODO: Localizza
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(product.ingredients!),
                    ),
                  ],
                ),

              // Allergeni (se presenti)
              if (product.allergens != null && product.allergens!.isNotEmpty)
                ExpansionTile(
                  title: const Text("Allergeni"), // TODO: Localizza
                  initiallyExpanded: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.allergens!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    },
  );
}

// Widget helper per le righe dei dettagli
Widget _buildDetailRow(BuildContext context, String label, Widget valueWidget) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        valueWidget,
      ],
    ),
  );
}

// Widget helper per il Nutri-Score
Widget _getNutriScoreWidget(BuildContext context, String? score) {
  if (score == null || score.isEmpty) return const Text("N/D");

  final Map<String, Color> colors = {
    'a': Colors.green.shade800,
    'b': Colors.green.shade500,
    'c': Colors.yellow.shade700,
    'd': Colors.orange.shade700,
    'e': Colors.red.shade700,
  };

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: colors[score.toLowerCase()] ?? Colors.grey,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      score.toUpperCase(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

// Widget helper per il gruppo NOVA
Widget _getNovaGroupWidget(BuildContext context, int? group) {
  if (group == null) return const Text("N/D");

  final Map<int, String> descriptions = {
    1: "Non processato",
    2: "Poco processato",
    3: "Processato",
    4: "Ultra-processato",
  };

  return Text(
    '${group} - ${descriptions[group] ?? ""}', // TODO: Localizza
    style: const TextStyle(fontWeight: FontWeight.bold),
  );
}
