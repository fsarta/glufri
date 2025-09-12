// lib/features/favorites/presentation/widgets/add_edit_favorite_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:uuid/uuid.dart';

void showAddEditFavoriteDialog(
  BuildContext context, {
  FavoriteProductModel? product,
  bool isFromScan = false,
}) {
  final isEditing = product != null;

  showDialog(
    context: context,
    builder: (ctx) =>
        _AddEditFavoriteDialogContent(product: product, isFromScan: isFromScan),
  );
}

class _AddEditFavoriteDialogContent extends ConsumerStatefulWidget {
  final FavoriteProductModel? product;
  final bool isFromScan;
  const _AddEditFavoriteDialogContent({this.product, this.isFromScan = false});

  @override
  ConsumerState<_AddEditFavoriteDialogContent> createState() =>
      _AddEditFavoriteDialogContentState();
}

class _AddEditFavoriteDialogContentState
    extends ConsumerState<_AddEditFavoriteDialogContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _priceController;
  late bool _isGlutenFree;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _barcodeController = TextEditingController(text: p?.barcode ?? '');
    _priceController = TextEditingController(
      text: p?.defaultPrice?.toString() ?? '',
    );
    _isGlutenFree = p?.isGlutenFree ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveFavorite() {
    if (!_formKey.currentState!.validate()) return;

    final newOrUpdatedProduct = FavoriteProductModel(
      id: widget.product?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      defaultPrice: double.tryParse(_priceController.text),
      isGlutenFree: _isGlutenFree,
    );

    ref.read(favoriteActionsProvider).addFavorite(newOrUpdatedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context); // Prendiamo il tema per i colori

    return AlertDialog(
      title: Text(
        widget.product != null
            ? l10n.addEditFavoriteDialogEdit
            : l10n.addEditFavoriteDialogAdd,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.productName),
                validator: (val) =>
                    (val?.trim().isEmpty ?? true) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _barcodeController,
                readOnly: widget.isFromScan, // Usa la variabile passata
                decoration: InputDecoration(
                  labelText: l10n.barcodeOptional,
                  prefixIcon: const Icon(Icons.qr_code_2), // Aggiungi l'icona
                  filled: widget.isFromScan,
                  fillColor: widget.isFromScan
                      ? theme.disabledColor.withOpacity(
                          0.1,
                        ) // Colora lo sfondo se readOnly
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: l10n.defaultPrice,
                  suffixText: "€",
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(l10n.glutenFreeProduct),
                value: _isGlutenFree,
                onChanged: (val) =>
                    setState(() => _isGlutenFree = val ?? false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _saveFavorite, child: Text(l10n.save)),
      ],
    );
  }
}
