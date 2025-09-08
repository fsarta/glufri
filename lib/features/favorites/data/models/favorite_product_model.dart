// lib/features/favorites/data/models/favorite_product_model.dart

import 'package:hive/hive.dart';

part 'favorite_product_model.g.dart';

@HiveType(typeId: 3) // <-- Nuovo typeId, assicurati sia univoco!
class FavoriteProductModel extends HiveObject {
  @HiveField(0)
  late String id; // UUID univoco

  @HiveField(1)
  late String name;

  @HiveField(2)
  String? barcode;

  @HiveField(3)
  bool isGlutenFree;

  @HiveField(4)
  double? defaultPrice; // Prezzo di default opzionale

  FavoriteProductModel({
    required this.id,
    required this.name,
    this.barcode,
    this.isGlutenFree = false,
    this.defaultPrice,
  });
}
