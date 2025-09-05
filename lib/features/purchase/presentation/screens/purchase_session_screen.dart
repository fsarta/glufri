import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/domain/entities/off_product.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/presentation/providers/product_api_provider.dart';
import 'package:glufri/features/scanner/presentation/screens/barcode_scanner_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class PurchaseSessionScreen extends ConsumerStatefulWidget {
  final PurchaseModel? purchaseToEdit;
  final bool isDuplicate;

  const PurchaseSessionScreen({
    super.key,
    this.purchaseToEdit,
    this.isDuplicate = false,
  });

  @override
  ConsumerState<PurchaseSessionScreen> createState() =>
      _PurchaseSessionScreenState();
}

class _PurchaseSessionScreenState extends ConsumerState<PurchaseSessionScreen> {
  final _storeNameController = TextEditingController();
  bool _isInitialized = false; // Flag per l'inizializzazione

  @override
  void initState() {
    super.initState();
    // Esegui la logica di caricamento qui.
    // Usiamo `Future.microtask` per assicurarci che la build iniziale sia completata
    // prima di tentare di modificare lo stato di un provider.
    // Questo previene potenziali errori di "modifying a provider during build".
    Future.microtask(() {
      final purchase = widget.purchaseToEdit;
      if (purchase != null) {
        // Chiama la funzione di caricamento sul notifier!
        ref
            .read(cartProvider.notifier)
            .loadPurchase(
              purchase,
              isDuplicate: widget.isDuplicate, // Passa anche questo flag!
            );
      }
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    if (!_isInitialized && cartState.storeName != null) {
      _storeNameController.text = cartState.storeName!;
      _isInitialized = true;
    }

    // Ascolta i cambiamenti futuri (utile se lo stato potesse cambiare da altrove)
    ref.listen<String?>(cartProvider.select((state) => state.storeName), (
      previous,
      next,
    ) {
      if (next != _storeNameController.text) {
        _storeNameController.text = next ?? '';
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.purchaseToEdit != null && !widget.isDuplicate
              ? l10n!.editPurchase
              : l10n!.newPurchase,
        ),
        actions: [
          // Bottone Salva abilitato solo se ci sono items
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilledButton.icon(
              icon: const Icon(Icons.save),
              label: Text(l10n!.savePurchase),
              onPressed: cartState.items.isNotEmpty
                  ? () async {
                      await ref.read(cartProvider.notifier).savePurchase(ref);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.purchaseSavedSuccess)),
                        );
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Metadata dell'acquisto
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _storeNameController,
              decoration: InputDecoration(
                labelText: l10n.store,
                hintText: 'Es. Supermercato Rossi',
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(cartProvider.notifier).setStoreName(value);
              },
            ),
          ),

          // Lista dei prodotti
          Expanded(
            child: cartState.items.isEmpty
                ? Center(child: Text(l10n.addProductToStart))
                : ListView.builder(
                    itemCount: cartState.items.length,
                    itemBuilder: (context, index) {
                      final item = cartState.items[index];
                      return ListTile(
                        leading: item.isGlutenFree
                            ? const Icon(Icons.verified, color: Colors.green)
                            : const Icon(Icons.shopping_cart_outlined),
                        title: Text(item.name),
                        subtitle: Text(
                          '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)} €',
                        ),
                        trailing: Text(
                          '${item.subtotal.toStringAsFixed(2)} €',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () =>
                            _showAddItemDialog(context, ref, item: item),
                      );
                    },
                  ),
          ),

          // Riepilogo e Totale
          _buildTotalSummary(context, cartState),

          // Pulsanti Azione
          _buildActionButtons(context, ref, l10n),
        ],
      ),
    );
  }
}

// UI per i bottoni
Widget _buildActionButtons(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.addItem),
            onPressed: () => _showAddItemDialog(context, ref),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(l10n.scanBarcode),
            onPressed: () async {
              final barcode = await Navigator.of(context).push<String>(
                MaterialPageRoute(
                  builder: (ctx) => const BarcodeScannerScreen(),
                ),
              );

              if (barcode != null && context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  final productInfo = await ref.read(
                    offProductProvider(barcode).future,
                  );
                  Navigator.pop(context); // Chiude il loading dialog

                  // Ora apri il dialog di aggiunta prodotto, pre-popolato
                  _showAddItemDialog(
                    context,
                    ref,
                    barcode: barcode,
                    offProduct: productInfo,
                  );
                } catch (e) {
                  Navigator.pop(
                    context,
                  ); // Chiude il loading dialog in caso di errore
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.productNotFoundOrNetworkError)),
                  );
                  // Apri comunque il dialog per l'inserimento manuale
                  _showAddItemDialog(context, ref, barcode: barcode);
                }
              }
            },
          ),
        ),
      ],
    ),
  );
}

// UI per il totale
Widget _buildTotalSummary(BuildContext context, CartState cartState) {
  final l10n = AppLocalizations.of(context)!;
  // Ora calcoliamo i totali direttamente dallo stato del carrello
  final double totalSg = cartState.items
      .where((i) => i.isGlutenFree)
      .fold(0.0, (sum, i) => sum + i.subtotal);

  final double totalRegular = cartState.items
      .where((i) => !i.isGlutenFree)
      .fold(0.0, (sum, i) => sum + i.subtotal);

  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
    ),
    child: Column(
      children: [
        if (totalSg > 0) ...[
          _TotalRow(l10n.totalGlutenFree, totalSg),
          const SizedBox(height: 8),
        ],
        if (totalRegular > 0) ...[
          _TotalRow(l10n.totalOther, totalRegular),
          const SizedBox(height: 8),
        ],
        const Divider(),
        _TotalRow(
          AppLocalizations.of(context)!.total,
          cartState.total,
          isTotal: true,
        ),
      ],
    ),
  );
}

// Funzione helper per mostrare il dialog di aggiunta/modifica
void _showAddItemDialog(
  BuildContext context,
  WidgetRef ref, {
  PurchaseItemModel? item,
  String? barcode,
  OffProduct? offProduct,
}) {
  final isEditing = item != null;
  final l10n = AppLocalizations.of(context)!;
  final formKey = GlobalKey<FormState>();
  final theme = Theme.of(context);
  // Determina se il barcode proviene da una scansione e quindi non deve essere modificato
  final bool isFromScan = barcode != null && offProduct != null;

  // Controller per i campi di testo. Pre-popolati se si modifica o si scansiona.
  final nameController = TextEditingController(
    text: item?.name ?? offProduct?.name ?? '',
  );
  final priceController = TextEditingController(
    text: item?.unitPrice.toString().replaceAll('.', ',') ?? '',
  );
  final quantityController = TextEditingController(
    text: item?.quantity.toString().replaceAll('.', ',') ?? '1',
  );

  final barcodeController = TextEditingController(
    text: item?.barcode ?? barcode ?? '',
  );

  File? _imageFile;
  if (item?.imagePath != null && item!.imagePath!.isNotEmpty) {
    _imageFile = File(item.imagePath!);
  }

  bool isGlutenFree = item?.isGlutenFree ?? false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Fondamentale per far spazio alla tastiera
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (modalContext, setStateDialog) {
          // Usiamo Padding per gestire lo spazio occupato dalla tastiera (viewInsets)
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            // SingleChildScrollView rende il contenuto scorrevole.
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Occupa solo lo spazio necessario
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isEditing ? l10n.editProduct : l10n.addItem,
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),
                    // ... (logica immagine, se presente, può andare qui)
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: l10n.productName),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.productNameCannotBeEmpty;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: priceController,
                            decoration: InputDecoration(
                              labelText: l10n.price,
                              suffixText: '€',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.requiredField;
                              }
                              // Gestisce sia il punto che la virgola
                              final normalizedValue = value.replaceAll(
                                ',',
                                '.',
                              );
                              if (double.tryParse(normalizedValue) == null) {
                                return l10n.invalidValue;
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: quantityController,
                            decoration: InputDecoration(
                              labelText: l10n.quantity,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.requiredField;
                              }
                              final normalizedValue = value.replaceAll(
                                ',',
                                '.',
                              );
                              if (double.tryParse(normalizedValue) == null) {
                                return l10n.invalidValue;
                              }
                              if (double.parse(normalizedValue) <= 0) {
                                return l10n.mustBeGreaterThanZero;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Campo Barcode (nella sua Row separata)
                    TextFormField(
                      controller: barcodeController,
                      readOnly: isFromScan,
                      decoration: InputDecoration(
                        labelText: l10n.barcodeOptional,
                        prefixIcon: const Icon(Icons.qr_code_2),
                        filled: isFromScan,
                        fillColor: isFromScan
                            ? theme.disabledColor.withOpacity(0.1)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16), // Spazio prima del checkbox
                    CheckboxListTile(
                      title: Text(l10n.glutenFreeProduct),
                      value: isGlutenFree,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          // Usa setStateDialog per aggiornare la UI del modal
                          isGlutenFree = value ?? false;
                        });
                      },
                      secondary: Icon(
                        Icons.verified,
                        color: isGlutenFree ? Colors.green : Colors.grey,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    const SizedBox(height: 24),
                    FilledButton(
                      child: Text(isEditing ? l10n.update : l10n.addItem),
                      onPressed: () async {
                        // La funzione diventa async
                        // 1. Controlla la validità del form
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        // 2. Converte i valori in modo sicuro (gestendo virgola/punto)
                        final priceText = priceController.text.replaceAll(
                          ',',
                          '.',
                        );
                        final quantityText = quantityController.text.replaceAll(
                          ',',
                          '.',
                        );

                        final price = double.parse(priceText);
                        final quantity = double.parse(quantityText);

                        // 3. Gestisce il salvataggio dell'immagine (se presente)
                        String? finalImagePath;
                        if (_imageFile != null) {
                          final appDir =
                              await getApplicationDocumentsDirectory();
                          final fileName = p.basename(_imageFile!.path);
                          final savedImage = await _imageFile!.copy(
                            p.join(appDir.path, fileName),
                          );
                          finalImagePath = savedImage.path;
                        }

                        // 4. Crea o aggiorna l'oggetto
                        final newItem = PurchaseItemModel(
                          id: item?.id ?? const Uuid().v4(),
                          name: nameController.text.trim(),
                          unitPrice: price,
                          quantity: quantity,
                          barcode: barcode ?? item?.barcode,
                          imagePath: finalImagePath,
                          isGlutenFree: isGlutenFree,
                        );

                        // 5. Aggiorna lo stato del carrello
                        final notifier = ref.read(cartProvider.notifier);
                        if (isEditing) {
                          notifier.updateItem(newItem);
                        } else {
                          notifier.addItem(newItem);
                        }

                        // 6. Chiudi il dialog
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _TotalRow(this.label, this.amount, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.titleLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('${amount.toStringAsFixed(2)} €', style: style),
      ],
    );
  }
}
