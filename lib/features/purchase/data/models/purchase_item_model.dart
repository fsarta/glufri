import 'package:glufri/features/purchase/domain/entities/unit_of_measure.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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

  @HiveField(7)
  double? unitValue; // Es: 500 (per 500g) o 1.5 (per 1.5L)

  @HiveField(8)
  String? unitOfMeasure; // Salvato come stringa per compatibilità JSON/Hive

  PurchaseItemModel({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.barcode,
    this.imagePath,
    this.isGlutenFree = false,
    this.unitValue,
    this.unitOfMeasure,
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
      'unitValue': unitValue,
      'unitOfMeasure': unitOfMeasure,
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
      unitValue: json['unitValue'],
      unitOfMeasure: json['unitOfMeasure'],
    );
  }

  /// Calcola il prezzo per unità standard (Kg, Litro o pezzo).
  /// Restituisce null se le informazioni non sono disponibili.
  double? get pricePerStandardUnit {
    if (unitValue == null || unitValue == 0 || unitOfMeasure == null) {
      return null;
    }

    try {
      final unitEnum = UnitOfMeasure.values.firstWhere(
        (e) => e.name == unitOfMeasure,
      );
      switch (unitEnum) {
        case UnitOfMeasure.grams:
          return unitPrice / (unitValue! / 1000); // Prezzo per Kg
        case UnitOfMeasure.kilograms:
          return unitPrice / unitValue!; // Già in Kg
        case UnitOfMeasure.milliliters:
          return unitPrice / (unitValue! / 1000); // Prezzo per Litro
        case UnitOfMeasure.liters:
          return unitPrice / unitValue!; // Già in Litro
        case UnitOfMeasure.pieces:
          return unitPrice / unitValue!; // Prezzo per singolo pezzo
      }
    } catch (e) {
      return null; // Se il parsing dell'enum fallisce
    }
  }

  /// Restituisce una stringa formattata per il prezzo per unità, es. "12,50 €/Kg".
  /// Restituisce una stringa vuota se non applicabile.
  String get pricePerStandardUnitDisplayString {
    final price = pricePerStandardUnit;
    if (price == null || unitOfMeasure == null) return '';

    final formattedPrice = NumberFormat.currency(
      locale: Intl.getCurrentLocale(),
      symbol: '€',
    ).format(price);

    final unitEnum = UnitOfMeasure.values.firstWhere(
      (e) => e.name == unitOfMeasure,
    );
    final unitSuffix = switch (unitEnum) {
      UnitOfMeasure.grams || UnitOfMeasure.kilograms => '/Kg',
      UnitOfMeasure.milliliters || UnitOfMeasure.liters => '/L',
      UnitOfMeasure.pieces => '/pz',
    };

    return '$formattedPrice$unitSuffix';
  }
}
