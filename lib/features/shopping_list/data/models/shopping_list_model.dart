// lib/features/shopping_list/data/models/shopping_list_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_item_model.dart';
import 'package:hive/hive.dart';

part 'shopping_list_model.g.dart';

@HiveType(typeId: 5)
class ShoppingListModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late DateTime dateCreated;

  @HiveField(3)
  late HiveList<ShoppingListItemModel> items;

  ShoppingListModel({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final itemsJson = items.map((item) => item.toJson()).toList();
    return {
      'id': id,
      'name': name,
      'dateCreated': Timestamp.fromDate(dateCreated),
      'items': itemsJson,
    };
  }

  factory ShoppingListModel.fromJson(
    Map<String, dynamic> json, {
    required HiveList<ShoppingListItemModel> items,
  }) {
    return ShoppingListModel(
      id: json['id'],
      name: json['name'],
      dateCreated: (json['dateCreated'] as Timestamp).toDate(),
      items: items,
    );
  }
}
