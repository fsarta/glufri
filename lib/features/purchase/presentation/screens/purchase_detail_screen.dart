import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final PurchaseModel purchase;

  const PurchaseDetailScreen({super.key, required this.purchase});

  @override
  ConsumerState<PurchaseDetailScreen> createState() =>
      _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends ConsumerState<PurchaseDetailScreen> {
  // Controller per catturare un widget come immagine.
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.purchase.store ?? 'Dettaglio Acquisto'),
        actions: [
          // Bottone diretto per la condivisione veloce.
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Condividi Riepilogo',
            onPressed: _sharePurchaseAsImage,
          ),
          // Menu a tendina per tutte le altre azioni.
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuSelection(value, context, ref),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_note),
                  title: Text('Modifica'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'duplicate',
                child: ListTile(
                  leading: Icon(Icons.copy_all_outlined),
                  title: Text('Duplica'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'export_csv',
                child: ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text('Esporta CSV (Pro)'),
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
                    'Elimina',
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
                Text(
                  widget.purchase.store ?? 'Nessun negozio specificato',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  // Usiamo un formato completo per il dettaglio
                  DateFormat(
                    'EEEE d MMMM yyyy, HH:mm:ss',
                  ).format(widget.purchase.date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '${widget.purchase.total.toStringAsFixed(2)} ${widget.purchase.currency}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.5),
          ListTile(
            title: Text(
              'Prodotti (${widget.purchase.items.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // Lista dei singoli prodotti acquistati.
          ...widget.purchase.items.map((item) {
            final hasImage =
                item.imagePath != null && item.imagePath!.isNotEmpty;
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
              title: Text(item.name),
              subtitle: Text(
                '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)} €',
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
  void _handleMenuSelection(String value, BuildContext context, WidgetRef ref) {
    switch (value) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                PurchaseSessionScreen(purchaseToEdit: widget.purchase),
          ),
        );
        break;
      case 'duplicate':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PurchaseSessionScreen(
              purchaseToEdit: widget.purchase,
              isDuplicate: true,
            ),
          ),
        );
        break;
      case 'export_csv':
        _exportPurchaseAsCsv(context, ref);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(context, ref);
        break;
    }
  }

  /// Genera un file CSV e avvia la condivisione nativa (solo per utenti Pro).
  Future<void> _exportPurchaseAsCsv(BuildContext context, WidgetRef ref) async {
    final isPro = ref.read(isProUserProvider);
    if (!isPro && context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const UpsellScreen()));
      return;
    }

    try {
      final csvData = ExportService().purchaseToCsv(widget.purchase);
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/glufri-export-${widget.purchase.id}.csv',
      );
      await file.writeAsString(csvData);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject:
            'Esportazione Acquisto Glufri - ${widget.purchase.store ?? ""}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore durante l\'esportazione.')),
        );
      }
    }
  }

  /// Cattura il widget di riepilogo come immagine e avvia la condivisione.
  Future<void> _sharePurchaseAsImage() async {
    try {
      final image = await _screenshotController.captureFromWidget(
        InheritedTheme.captureAll(
          context,
          Material(child: PurchaseSummaryCard(purchase: widget.purchase)),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/glufri-share-${widget.purchase.id}.png',
      );
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Ecco il mio ultimo acquisto senza glutine tracciato con l\'app Glufri! 🛒',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore durante la condivisione.')),
        );
      }
    }
  }

  /// Mostra un dialogo di conferma prima di eliminare definitivamente un acquisto.
  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma Eliminazione'),
        content: const Text(
          'Sei sicuro di voler eliminare questo acquisto? L\'azione è irreversibile.',
        ),
        actions: [
          TextButton(
            child: const Text('Annulla'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Elimina'),
            onPressed: () async {
              await ref
                  .read(purchaseRepositoryProvider)
                  .deletePurchase(widget.purchase.id);
              ref.invalidate(purchaseListProvider); // Aggiorna la cronologia

              if (context.mounted) {
                Navigator.of(ctx).pop(); // Chiude il dialogo
                Navigator.of(context).pop(); // Torna alla cronologia
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Acquisto eliminato con successo.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
