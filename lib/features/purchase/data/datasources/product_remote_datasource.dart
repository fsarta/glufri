import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:glufri/features/purchase/domain/entities/off_product.dart';

abstract class ProductRemoteDataSource {
  Future<OffProduct?> getProductByBarcode(String barcode);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://world.openfoodfacts.org/api/v2/product/';

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<OffProduct?> getProductByBarcode(String barcode) async {
    const fieldsToFetch =
        'product_name_it,product_name_en,product_name,brands,image_front_url'
        ',ingredients_text_it,ingredients_text' // Lista ingredienti (con fallback in inglese)
        ',allergens_from_ingredients' // Allergeni
        ',nutriscore_grade' // Punteggio Nutri-Score (es. 'a', 'b', 'c')
        ',nova_group'; // Gruppo NOVA (es. 1, 2, 3, 4)

    final response = await client
        .get(Uri.parse('$baseUrl$barcode?fields=$fieldsToFetch'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1 && data['product'] != null) {
        return OffProduct.fromJson(data);
      }
    }
    return null;
  }
}
