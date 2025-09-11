// lib/features/purchase/presentation/screens/purchase_detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/screens/upsell_screen.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/domain/services/export_service.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_session_screen.dart';
import 'package:glufri/features/purchase/presentation/widgets/purchase_summary_card.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

/// Schermata che mostra i dettagli di un singolo acquisto salvato.
/// È un ConsumerStatefulWidget per poter utilizzare un `ScreenshotController`
/// che richiede di essere inizializzato e mantenuto nello stato del widget.
class PurchaseDetailScreen extends ConsumerStatefulWidget {
  final String purchaseId;

  const PurchaseDetailScreen({super.key, required this.purchaseId});

  @override
  ConsumerState<PurchaseDetailScreen> createState() =>
      _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends ConsumerState<PurchaseDetailScreen> {
  // Controller per catturare un widget come immagine.
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    // Guarda il nuovo provider usando l'ID passato
    final purchase = ref.watch(singlePurchaseProvider(widget.purchaseId));

    // Gestisci il caso in cui l'acquisto non sia (ancora) disponibile o sia stato cancellato
    if (purchase == null) {
      // Mostra uno stato di caricamento o un messaggio se l'acquisto non c'è più
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(purchase.store ?? l10n.purchaseDetail),
        actions: [
          // Bottone diretto per la condivisione veloce.
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: l10n.shareSummary,
            onPressed: () => _sharePurchaseAsImage(purchase),
          ),
          // Menu a tendina per tutte le altre azioni.
          PopupMenuButton<String>(
            onSelected: (value) =>
                _handleMenuSelection(value, context, ref, purchase),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: const Icon(Icons.edit_note),
                  title: Text(l10n.edit),
                ),
              ),
              PopupMenuItem<String>(
                value: 'duplicate',
                child: ListTile(
                  leading: const Icon(Icons.copy_all_outlined),
                  title: Text(l10n.duplicate),
                ),
              ),
              PopupMenuItem<String>(
                value: 'export_csv',
                child: ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.exportCsvPro),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    l10n.delete,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // Sezione di riepilogo con i dettagli principali dell'acquisto.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Manteniamo le informazioni sul negozio e sulla data
                Text(
                  purchase.store ?? l10n.noStoreSpecified,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE d MMMM yyyy, HH:mm').format(purchase.date),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 24), // Un po' più di spazio
                // --- Inizia la nuova sezione dei totali dettagliati ---
                // Questa Column interna è quella che ti avevo dato prima
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // Allarga gli elementi
                  children: [
                    _TotalDetailRow(
                      l10n.totalGlutenFree,
                      purchase.totalGlutenFree,
                      context,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _TotalDetailRow(
                      l10n.totalOther,
                      purchase.totalRegular,
                      context,
                    ),
                    const Divider(height: 24, thickness: 1.0),
                    _TotalDetailRow(
                      l10n.totalOverall,
                      purchase.total,
                      context,
                      isTotal: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.5),
          ListTile(
            title: Text(
              l10n.productsCount(purchase.items.length),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // Lista dei singoli prodotti acquistati.
          ...purchase.items.map((item) {
            final hasImage =
                item.imagePath != null && item.imagePath!.isNotEmpty;
            final priceInfo =
                '${item.quantity} x ${NumberFormat.currency(locale: 'it_IT', symbol: '€').format(item.unitPrice)}';
            final unitPriceInfo = item.pricePerStandardUnitDisplayString;
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: hasImage
                      ? Image.file(
                          File(item.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                ),
              ),
              title: Row(
                children: [
                  Text(item.name),
                  if (item.isGlutenFree) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, size: 16, color: Colors.green),
                  ],
                ],
              ),
              subtitle: Text(
                unitPriceInfo.isNotEmpty
                    ? '$priceInfo  •  $unitPriceInfo'
                    : priceInfo,
              ),
              trailing: Text(
                '${item.subtotal.toStringAsFixed(2)} €',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Gestisce la selezione di un'opzione dal menu a tendina.
  void _handleMenuSelection(
    String value,
    BuildContext context,
    WidgetRef ref,
    PurchaseModel purchase,
  ) {
    switch (value) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PurchaseSessionScreen(purchaseToEdit: purchase),
          ),
        );
        break;
      case 'duplicate':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PurchaseSessionScreen(
              purchaseToEdit: purchase,
              isDuplicate: true,
            ),
          ),
        );
        break;
      case 'export_csv':
        _exportPurchaseAsCsv(context, ref, purchase);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(context, ref, purchase);
        break;
    }
  }

  /// Genera un file CSV e avvia la condivisione nativa (solo per utenti Pro).
  Future<void> _exportPurchaseAsCsv(
    BuildContext context,
    WidgetRef ref,
    PurchaseModel purchase,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final isPro = ref.read(isProUserProvider);
    if (!isPro && context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const UpsellScreen()));
      return;
    }

    try {
      final csvData = ExportService().purchaseToCsv(purchase);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/glufri-export-${purchase.id}.csv');
      await file.writeAsString(csvData);

      await Share.shareXFiles([
        XFile(file.path),
      ], subject: l10n.purchaseExport(purchase.store ?? ""));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.exportError)));
      }
    }
  }

  /// Cattura il widget di riepilogo come immagine e avvia la condivisione.
  Future<void> _sharePurchaseAsImage(PurchaseModel purchase) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final image = await _screenshotController.captureFromWidget(
        InheritedTheme.captureAll(
          context,
          Material(child: PurchaseSummaryCard(purchase: purchase)),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/glufri-share-${purchase.id}.png');
      await file.writeAsBytes(image);

      await Share.shareXFiles([XFile(file.path)], text: l10n.shareText);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.shareError)));
      }
    }
  }

  /// Mostra un dialogo di conferma prima di eliminare definitivamente un acquisto.
  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    PurchaseModel purchase,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmationTitle),
        content: Text(l10n.deleteConfirmationMessage),
        actions: [
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
            onPressed: () async {
              await ref
                  .read(purchaseRepositoryProvider)
                  .deletePurchase(purchase.id);
              ref.invalidate(purchaseListProvider); // Aggiorna la cronologia

              if (context.mounted) {
                Navigator.of(ctx).pop(); // Chiude il dialogo
                Navigator.of(context).pop(); // Torna alla cronologia
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.purchaseDeletedSuccess)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TotalDetailRow extends StatelessWidget {
  final String label;
  final double amount;
  final BuildContext context;
  final bool isTotal;
  final Color? color;

  const _TotalDetailRow(
    this.label,
    this.amount,
    this.context, {
    this.isTotal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.titleLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style?.copyWith(color: color)),
        Text(
          '${amount.toStringAsFixed(2)} €',
          style: style?.copyWith(
            fontWeight: FontWeight.bold,
            color:
                color ??
                (isTotal ? Theme.of(context).colorScheme.primary : null),
          ),
        ),
      ],
    );
  }
}
