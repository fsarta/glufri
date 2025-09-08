// lib/features/purchase/domain/entities/product_price_history.dart
import 'package:flutter/foundation.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';

@immutable
class ProductPriceHistory {
  /// Il `PurchaseItemModel` dell'acquisto più recente.
  final PurchaseItemModel lastPurchaseItem;

  /// Il `PurchaseModel` che contiene l'acquisto più recente, per avere il contesto (data e negozio).
  final PurchaseModel lastPurchaseContext;

  /// Quante volte il prodotto è stato acquistato in totale.
  final int totalOccurrences;

  /// Il prezzo più basso mai pagato per questo prodotto.
  final double lowestPrice;

  /// Il prezzo più alto mai pagato per questo prodotto.
  final double highestPrice;

  const ProductPriceHistory({
    required this.lastPurchaseItem,
    required this.lastPurchaseContext,
    required this.totalOccurrences,
    required this.lowestPrice,
    required this.highestPrice,
  });
}
