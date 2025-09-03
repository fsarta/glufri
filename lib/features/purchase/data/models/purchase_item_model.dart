import 'package:hive/hive.dart';

part 'purchase_item_model.g.dart';

@HiveType(typeId: 1)
class PurchaseItemModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late double unitPrice;

  @HiveField(3)
  late double quantity;

  @HiveField(4)
  String? barcode;

  @HiveField(5)
  String? imagePath; // Percorso nel filesystem locale

  PurchaseItemModel({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.barcode,
    this.imagePath,
  });

  double get subtotal => unitPrice * quantity;
}
