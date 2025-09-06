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

  @HiveField(6)
  late bool isGlutenFree;

  PurchaseItemModel({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.barcode,
    this.imagePath,
    this.isGlutenFree = false,
  });

  double get subtotal => unitPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'barcode': barcode,
      'imagePath':
          imagePath, // Nota: imagePath è locale, non funzionerà su altri device
      'isGlutenFree': isGlutenFree,
    };
  }

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      id: json['id'],
      name: json['name'],
      unitPrice: json['unitPrice'],
      quantity: (json['quantity'] as num).toDouble(),
      barcode: json['barcode'],
      imagePath: json['imagePath'],
      isGlutenFree: json['isGlutenFree'],
    );
  }
}
