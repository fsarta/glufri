// lib/features/purchase/presentation/screens/purchase_session_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/core/providers/connectivity_provider.dart';
import 'package:glufri/features/budget/presentation/providers/budget_providers.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:glufri/features/monetization/presentation/providers/interstitial_ad_manager.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/screens/upsell_screen.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/domain/entities/off_product.dart';
import 'package:glufri/features/purchase/domain/entities/product_price_history.dart';
import 'package:glufri/features/purchase/domain/entities/unit_of_measure.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/presentation/providers/product_api_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/purchase/presentation/widgets/product_details_bottom_sheet.dart';
import 'package:glufri/features/scanner/presentation/screens/barcode_scanner_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  void _showOfflineSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Questa funzione richiede una connessione internet.",
        ), // TODO: Localizza
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Esegui la logica di caricamento qui.
    // Usiamo `Future.microtask` per assicurarci che la build iniziale sia completata
    // prima di tentare di modificare lo stato di un provider.
    // Questo previene potenziali errori di 'modifying a provider during build'.
    Future.microtask(() {
      final isPro = ref.read(isProUserProvider);
      if (!isPro) {
        ref.read(interstitialAdManagerProvider).loadAd();
      }

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
    final isPro = ref.watch(isProUserProvider);

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
                      // Prima salva l'acquisto
                      await ref.read(cartProvider.notifier).savePurchase();

                      if (!context.mounted) return;

                      // Mostra la conferma all'utente SUBITO
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.purchaseSavedSuccess)),
                      );

                      // Funzione che chiude la pagina
                      final void Function() navigateBack = () {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      };

                      // Ora gestisci l'annuncio o la navigazione
                      final isPro = ref.read(isProUserProvider);
                      if (!isPro) {
                        // Se l'utente non è Pro, prova a mostrare l'annuncio.
                        // La navigazione indietro avverrà DOPO che l'annuncio è stato chiuso.
                        ref
                            .read(interstitialAdManagerProvider)
                            .showAdIfAvailable(onAdDismissed: navigateBack);
                      } else {
                        // Se l'utente è Pro, torna indietro subito.
                        navigateBack();
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextFormField(
              controller: _storeNameController,
              decoration: InputDecoration(
                labelText: l10n.store,
                hintText: l10n.storeHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(cartProvider.notifier).setStoreName(value);
              },
            ),
          ),
          Expanded(
            child: cartState.items.isEmpty
                ? Center(child: Text(l10n.addProductToStart))
                : ListView.builder(
                    itemCount: cartState.items.length,
                    itemBuilder: (context, index) {
                      final item = cartState.items[index];
                      if (index == 0) {
                        // Stampiamo solo per il primo item per non intasare la console
                        debugPrint('--- [DEBUG 3: VISUALIZZAZIONE UI] ---');
                        debugPrint('Visualizzando item: ${item.name}');
                        debugPrint(
                          'Item dal provider ha unitValue: ${item.unitValue}',
                        );
                        debugPrint(
                          'Item dal provider ha unitOfMeasure: ${item.unitOfMeasure}',
                        );
                        debugPrint(
                          'Risultato del calcolo: ${item.pricePerStandardUnitDisplayString}',
                        );
                        debugPrint('------------------------------------');
                      }
                      final priceInfo =
                          '${item.quantity} x ${NumberFormat.currency(locale: 'it_IT', symbol: '€').format(item.unitPrice)}';
                      final unitPriceInfo =
                          item.pricePerStandardUnitDisplayString;
                      return Slidable(
                        key: ValueKey(item.id),
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            // AZIONE: Dettagli Prodotto
                            // La mostriamo solo se l'item ha un barcode
                            if (item.barcode != null &&
                                item.barcode!.isNotEmpty &&
                                isPro)
                              SlidableAction(
                                onPressed: (context) async {
                                  // Aggiungi il controllo di connessione
                                  if (!ref.read(hasConnectionProvider)) {
                                    _showOfflineSnackbar();
                                    return;
                                  }
                                  // Mostriamo un caricamento perché dobbiamo fare la chiamata API
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (ctx) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                  try {
                                    final offProduct = await ref.read(
                                      offProductProvider(item.barcode!).future,
                                    );
                                    // Togliamo il dialog di caricamento
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();

                                    if (context.mounted && offProduct != null) {
                                      showProductDetailsBottomSheet(
                                        context,
                                        offProduct,
                                      );
                                    } else if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.productNotFoundOrNetworkError,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    // Assicurati di chiudere il dialogo anche in caso di errore
                                    if (context.mounted) {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.productNotFoundOrNetworkError,
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                icon: Icons.info_outline,
                                label: "Dettagli", // TODO: Localizza
                                //borderRadius: BorderRadius.circular(12),
                              ),

                            // AZIONE: Elimina
                            SlidableAction(
                              onPressed: (context) {
                                // Non serve un'ulteriore conferma qui, l'azione
                                // di per sé è a basso rischio in questa schermata.
                                ref
                                    .read(cartProvider.notifier)
                                    .removeItem(item.id);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: l10n.delete,
                              //borderRadius: BorderRadius.circular(12),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: item.isGlutenFree
                              ? const Icon(Icons.verified, color: Colors.green)
                              : const Icon(Icons.shopping_cart_outlined),
                          title: Text(item.name),
                          subtitle: Text(
                            unitPriceInfo.isNotEmpty
                                ? '$priceInfo  •  $unitPriceInfo' // Se c'è prezzo/kg, lo mostriamo
                                : priceInfo, // Altrimenti solo il normale sottotitolo
                          ),
                          trailing: Text(
                            '${item.subtotal.toStringAsFixed(2)} €',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () =>
                              _showAddItemDialog(context, ref, item: item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // --- NUOVA PARTE: USA IL bottomNavigationBar ---
      // Usiamo SafeArea per assicurarci che i pulsanti non finiscano sotto
      // le barre di sistema inferiori (es. la home bar su iOS)
      bottomNavigationBar: SafeArea(
        child: Material(
          elevation: 16.0,
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // La Colonna è alta solo quanto il suo contenuto
            children: [
              const _TotalSummarySection(),
              Padding(
                // Un po' di padding per staccare i pulsanti dal bordo
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: _buildActionButtons(context, ref, l10n),
              ),
            ],
          ),
        ),
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
  final isPro = ref.watch(isProUserProvider);

  // Funzione helper locale (il context è già disponibile)
  void _showOfflineSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Questa funzione richiede una connessione internet.",
        ), // TODO: Localizza
        backgroundColor: Colors.orange,
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      // Trasformiamo in Column per avere due righe
      children: [
        // --- Prima riga con i pulsanti principali ---
        Row(
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
                  // Aggiungi il controllo PRIMA di avviare lo scanner
                  // (non ha senso scansionare se poi non possiamo fare la chiamata API)
                  if (!ref.read(hasConnectionProvider)) {
                    _showOfflineSnackbar();
                    return;
                  }
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

                    // 1. Controlla se l'utente è Pro PRIMA di fare la ricerca nella cronologia
                    final isPro = ref.read(isProUserProvider);

                    // Prepariamo i future, ma eseguiremo quello della cronologia solo se necessario
                    final apiResultFuture = ref.read(
                      offProductProvider(barcode).future,
                    );

                    // Future condizionale per la cronologia
                    final Future<ProductPriceHistory?> historyResultFuture =
                        isPro
                        ? ref.read(productHistoryProvider(barcode).future)
                        : Future.value(
                            null,
                          ); // Se non è Pro, il risultato sarà sempre null

                    // Usiamo 'Future.wait<dynamic>' per evitare problemi con i tipi
                    final List<dynamic> results = await Future.wait([
                      apiResultFuture,
                      historyResultFuture,
                    ]);

                    final apiResult = results[0]; // Questo è OffProduct?
                    final historyResult = results[1] as ProductPriceHistory?;

                    // Ora che abbiamo entrambi i risultati, chiudiamo il dialog di caricamento
                    if (context.mounted) Navigator.pop(context);

                    // 2. Se abbiamo trovato una cronologia, la mostriamo
                    if (context.mounted && historyResult != null) {
                      await _showPriceHistoryBottomSheet(
                        context,
                        l10n,
                        historyResult,
                      );
                    }

                    final offProduct = apiResult is OffProduct
                        ? apiResult
                        : null;
                    if (context.mounted && offProduct != null && isPro) {
                      // Aspetta che il bottom sheet venga chiuso prima di procedere
                      await showProductDetailsBottomSheet(context, offProduct);
                    }

                    // Aggiungiamo un feedback per l'utente NON-PRO quando scansiona un prodotto
                    // per fargli sapere cosa si sta perdendo.
                    if (context.mounted && offProduct != null && !isPro) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Passa a Pro per vedere ingredienti e Nutri-Score!",
                          ), // TODO: Localizza
                          action: SnackBarAction(
                            label: l10n.unlockPro,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UpsellScreen(),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    // Aggiungiamo un piccolo feedback visivo per gli utenti non-Pro
                    // che scansionano un prodotto che avrebbero in cronologia (ma non possono vederla)
                    if (context.mounted && !isPro) {
                      // Controlliamo in background (senza 'await') se ci sarebbero stati risultati
                      ref.read(productHistoryProvider(barcode).future).then((
                        history,
                      ) {
                        if (history != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.proRequiredForHistory),
                              action: SnackBarAction(
                                label: l10n.unlockPro,
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const UpsellScreen(),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    }

                    // 3. Apriamo il dialogo di aggiunta prodotto, come prima
                    if (context.mounted) {
                      // L'apiResult qui potrebbe essere un `OffProduct` o `null`
                      final offProduct = apiResult is OffProduct
                          ? apiResult
                          : null;

                      _showAddItemDialog(
                        context,
                        ref,
                        barcode: barcode,
                        offProduct: offProduct,
                        // Pre-compiliamo il prezzo con l'ultimo prezzo pagato!
                        lastPrice: historyResult?.lastPurchaseItem.unitPrice,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),

        if (isPro) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.favorite),
              label: const Text('Aggiungi da Preferiti'), // TODO: Localizza
              onPressed: () async {
                // Apriamo un nuovo BottomSheet per mostrare i preferiti
                final favorites = await ref.read(favoriteListProvider.future);
                if (context.mounted) {
                  _showFavoritesPicker(context, ref, favorites);
                }
              },
            ),
          ),
        ],
      ],
    ),
  );
}

// UI per il totale
Widget _buildTotalSummary(BuildContext context, WidgetRef ref) {
  // <-- Ora riceve ref
  final l10n = AppLocalizations.of(context)!;
  final cartState = ref.watch(cartProvider); // Osserva il carrello
  final isPro = ref.watch(isProUserProvider); // Controlla se è Pro

  final double totalSg = cartState.items
      .where((i) => i.isGlutenFree)
      .fold(0.0, (sum, i) => sum + i.subtotal);

  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 8,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- NUOVO WIDGET PER IL RESIDUO DEL BUDGET ---
        // Lo mostriamo solo se l'utente è Pro
        if (isPro)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _BudgetResidueView(),
          ),

        if (totalSg > 0) ...[
          _TotalRow(l10n.totalGlutenFree, totalSg),
          const SizedBox(height: 8),
        ],
        _TotalRow(l10n.total, cartState.total, isTotal: true),
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
  double? lastPrice,
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
    // Se c'è un `lastPrice`, usalo! Altrimenti usa il prezzo dell'item in modifica, altrimenti vuoto
    text:
        item?.unitPrice.toString().replaceAll('.', ',') ??
        (lastPrice?.toString().replaceAll('.', ',') ?? ''),
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
  bool saveAsFavorite = false;

  final unitValueController = TextEditingController(
    text: item?.unitValue?.toString().replaceAll('.', ',') ?? '',
  );
  String? selectedUnit = item?.unitOfMeasure;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (isEditing)
                          const SizedBox(width: 48)
                        else
                          const Spacer(),
                        Expanded(
                          child: Text(
                            isEditing ? l10n.editProduct : l10n.addItem,
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (isEditing)
                          IconButton(
                            tooltip: l10n.delete,
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .removeItem(item!.id);
                              Navigator.of(ctx).pop();
                            },
                          )
                        else
                          const Spacer(),
                      ],
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

                    ExpansionTile(
                      title: Text(l10n.optionalDetails),
                      tilePadding: EdgeInsets.zero,
                      initiallyExpanded: item?.unitValue != null,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: unitValueController,
                                decoration: InputDecoration(
                                  labelText: l10n.weightVolumePieces,
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedUnit,
                                hint: Text(l10n.unit),
                                items: UnitOfMeasure.values
                                    .map(
                                      (unit) => DropdownMenuItem(
                                        value: unit.name,
                                        child: Text(
                                          unit.name,
                                        ), // Potresti localizzare anche questi
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setStateDialog(() {
                                    selectedUnit = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

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

                    // --- NUOVO CHECKBOX (da aggiungere PRIMA del pulsante Salva) ---
                    // Lo mostriamo solo se l'item non è già un preferito (logica futura)
                    // e se è un nuovo prodotto
                    if (item == null)
                      CheckboxListTile(
                        title: Text(l10n.addToFavorites),
                        value: saveAsFavorite,
                        onChanged: (val) =>
                            setStateDialog(() => saveAsFavorite = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                    const SizedBox(height: 8),

                    FilledButton(
                      child: Text(isEditing ? l10n.update : l10n.addItem),
                      onPressed: () async {
                        // La funzione diventa async
                        // 1. Controlla la validità del form
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        // 2. Converte i valori in modo sicuro (gestendo virgola/punto)
                        final unitValueText = unitValueController.text
                            .replaceAll(',', '.');
                        final priceText = priceController.text.replaceAll(
                          ',',
                          '.',
                        );
                        final quantityText = quantityController.text.replaceAll(
                          ',',
                          '.',
                        );

                        debugPrint('--- [DEBUG 1: CATTURA UI] ---');
                        debugPrint(
                          'Valore del peso/volume (stringa): "${unitValueController.text}"',
                        );
                        debugPrint(
                          'Unità di misura selezionata: $selectedUnit',
                        );
                        debugPrint('----------------------------------');

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
                          unitValue: unitValueText.isEmpty
                              ? null
                              : double.tryParse(unitValueText),
                          unitOfMeasure: selectedUnit,
                        );

                        debugPrint('--- [DEBUG 2: CREAZIONE MODELLO] ---');
                        debugPrint(
                          'Oggetto newItem.unitValue: ${newItem.unitValue}',
                        );
                        debugPrint(
                          'Oggetto newItem.unitOfMeasure: ${newItem.unitOfMeasure}',
                        );
                        debugPrint(
                          'Calcolo prezzo/unità: ${newItem.pricePerStandardUnitDisplayString}',
                        );
                        debugPrint('----------------------------------');

                        if (saveAsFavorite) {
                          await ref
                              .read(favoriteActionsProvider)
                              .addFavoriteFromItem(newItem);
                        }

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

Future<void> _showPriceHistoryBottomSheet(
  BuildContext context,
  AppLocalizations l10n,
  ProductPriceHistory history,
) {
  final lastPurchase = history.lastPurchaseItem;
  final lastContext = history.lastPurchaseContext;

  return showModalBottomSheet(
    context: context,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.productHistoryTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.titleLarge,
                children: [
                  TextSpan(text: '${l10n.lastPrice} '),
                  TextSpan(
                    text: '${lastPurchase.unitPrice.toStringAsFixed(2)} €',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        ' ${l10n.atStore} ${lastContext.store ?? l10n.genericPurchase}',
                  ),
                ],
              ),
            ),
            Text(
              DateFormat.yMMMd(l10n.localeName).format(lastContext.date),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.purchasedXTimes(history.totalOccurrences),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (history.lowestPrice != history.highestPrice)
              Text(
                l10n.priceRange(
                  history.lowestPrice.toStringAsFixed(2),
                  history.highestPrice.toStringAsFixed(2),
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),

            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.of(ctx).pop(),
              icon: const Icon(Icons.arrow_forward),
              label: Text(l10n.continueAction),
            ),
          ],
        ),
      );
    },
  );
}

class _BudgetResidueView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final residue = ref.watch(budgetResidueProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Non mostrare nulla se nessun budget è impostato
    if (residue.residueGlutenFree == null && residue.residueTotal == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.remainingBudget,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const Divider(height: 12),

          if (residue.residueTotal != null)
            _ResidueRow(label: 'Totale', amount: residue.residueTotal!),

          if (residue.residueGlutenFree != null && residue.residueTotal != null)
            const SizedBox(height: 4),

          if (residue.residueGlutenFree != null)
            _ResidueRow(
              label: 'Senza Glutine',
              amount: residue.residueGlutenFree!,
            ),
        ],
      ),
    );
  }
}

class _ResidueRow extends StatelessWidget {
  final String label;
  final double amount;
  const _ResidueRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    // Il colore diventa rosso se il budget è stato sforato
    final color = amount < 0 ? Colors.red.shade700 : Colors.grey.shade800;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color)), // TODO: Localizza
        Text(
          '${amount.toStringAsFixed(2)} €',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

class _TotalSummarySection extends ConsumerWidget {
  const _TotalSummarySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cartState = ref.watch(cartProvider);
    final isPro = ref.watch(isProUserProvider);

    final double totalSg = cartState.items
        .where((i) => i.isGlutenFree)
        .fold(0.0, (sum, i) => sum + i.subtotal);

    final double totalOther = cartState.total - totalSg;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mostriamo il residuo del budget solo se l'utente è Pro
          if (isPro)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _BudgetResidueView(), // Questo widget già usa Consumer
            ),

          if (totalSg > 0) ...[
            _TotalRow(l10n.totalGlutenFree, totalSg),
            const SizedBox(height: 8),
          ],

          // Abbiamo riaggiunto il totale 'Altro' per un riepilogo completo
          if (totalOther > 0) ...[
            _TotalRow(l10n.totalOther, totalOther),
            const SizedBox(height: 8),
          ],

          const Divider(),
          _TotalRow(l10n.total, cartState.total, isTotal: true),
        ],
      ),
    );
  }
}

void _showFavoritesPicker(
  BuildContext context,
  WidgetRef ref,
  List<FavoriteProductModel> favorites,
) {
  final l10n = AppLocalizations.of(context)!;

  if (favorites.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.noFavoritesAvailable))); // TODO
    return;
  }

  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return ListTile(
            title: Text(product.name),
            leading: Icon(product.isGlutenFree ? Icons.verified : Icons.label),
            onTap: () {
              final newItem = PurchaseItemModel(
                id: const Uuid().v4(),
                name: product.name,
                unitPrice: product.defaultPrice ?? 0.0,
                quantity: 1, // Di default 1, poi l'utente lo modifica
                barcode: product.barcode,
                isGlutenFree: product.isGlutenFree,
              );
              ref.read(cartProvider.notifier).addItem(newItem);
              Navigator.of(ctx).pop();
            },
          );
        },
      );
    },
  );
}
