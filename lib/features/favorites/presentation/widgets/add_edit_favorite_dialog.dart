// lib/features/favorites/presentation/widgets/add_edit_favorite_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:uuid/uuid.dart';

void showAddEditFavoriteDialog(
  BuildContext context, {
  FavoriteProductModel? product,
}) {
  final isEditing = product != null;

  showDialog(
    context: context,
    builder: (ctx) => _AddEditFavoriteDialogContent(product: product),
  );
}

class _AddEditFavoriteDialogContent extends ConsumerStatefulWidget {
  final FavoriteProductModel? product;
  const _AddEditFavoriteDialogContent({this.product});

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
    return AlertDialog(
      title: Text(
        widget.product != null ? "Modifica Preferito" : "Aggiungi Preferito",
      ), //TODO: l10n
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome Prodotto",
                ), // TODO:
                validator: (val) =>
                    (val?.trim().isEmpty ?? true) ? "Campo obbligatorio" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: "Codice a Barre (Opzionale)",
                ), // TODO:
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Prezzo di Default (Opzionale)",
                  suffixText: "€",
                ), // TODO:
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text("Prodotto Senza Glutine"), //TODO
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
          child: const Text("Annulla"),
        ),
        FilledButton(onPressed: _saveFavorite, child: const Text("Salva")),
      ],
    );
  }
}
