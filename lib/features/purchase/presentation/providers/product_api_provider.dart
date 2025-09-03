import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/purchase/data/datasources/product_remote_datasource.dart';
import 'package:glufri/features/purchase/domain/entities/off_product.dart';
import 'package:http/http.dart' as http;

// Fornisce l'istanza del client http
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Fornisce l'implementazione del datasource
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  return ProductRemoteDataSourceImpl(ref.watch(httpClientProvider));
});

// FutureProvider.family per ottenere un prodotto tramite barcode
final offProductProvider = FutureProvider.family<OffProduct?, String>((
  ref,
  barcode,
) async {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return remoteDataSource.getProductByBarcode(barcode);
});
