class OffProduct {
  final String barcode;
  final String? name;
  final String? brand;
  final String? imageUrl;

  OffProduct({required this.barcode, this.name, this.brand, this.imageUrl});

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
    );
  }
}
