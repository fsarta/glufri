// lib/features/shopping_list/data/models/shopping_list_item_model.dart

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'shopping_list_item_model.g.dart';

@HiveType(typeId: 4) // <-- Nuovo typeId, assicurati sia univoco
class ShoppingListItemModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  double quantity;

  @HiveField(3)
  bool isChecked;

  @HiveField(4)
  bool isGlutenFree;

  ShoppingListItemModel({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.isChecked = false,
    this.isGlutenFree = false,
  });
}
