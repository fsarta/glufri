import 'package:hive/hive.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';

part 'purchase_model.g.dart';

@HiveType(typeId: 0)
class PurchaseModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  String? store;

  @HiveField(3)
  late double total;

  @HiveField(4)
  late List<PurchaseItemModel> items;

  @HiveField(5)
  String currency;

  PurchaseModel({
    required this.id,
    required this.date,
    this.store,
    required this.total,
    required this.items,
    this.currency = 'EUR',
  });
}
