class OffProduct {
  final String barcode;
  final String? name;
  final String? brand;
  final String? imageUrl;
  final String? ingredients;
  final String? allergens;
  final String? nutriScore; // Es. 'a', 'b', 'c', 'd', 'e'
  final int? novaGroup; // Es. 1, 2, 3, 4

  OffProduct({
    required this.barcode,
    this.name,
    this.brand,
    this.imageUrl,
    this.ingredients,
    this.allergens,
    this.nutriScore,
    this.novaGroup,
  });

  factory OffProduct.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    if (productJson == null) {
      throw const FormatException('Product data is missing');
    }

    // Prova a prendere il nome del prodotto da diversi campi in ordine di preferenza
    final name =
        productJson['product_name_it'] ??
        productJson['product_name_en'] ??
        productJson['product_name'] ??
        '';

    return OffProduct(
      barcode: json['code'] as String,
      name: name.isNotEmpty ? name : null,
      brand: productJson['brands'] as String?,
      imageUrl: productJson['image_front_url'] as String?,
      ingredients:
          productJson['ingredients_text_it'] ?? productJson['ingredients_text'],
      allergens: productJson['allergens_from_ingredients'] as String?,
      nutriScore: productJson['nutriscore_grade'] as String?,
      // Usiamo int.tryParse per sicurezza, nel caso il valore non fosse un numero
      novaGroup: int.tryParse(productJson['nova_group']?.toString() ?? ''),
    );
  }
}
