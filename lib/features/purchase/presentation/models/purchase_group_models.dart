// lib/features/purchase/presentation/models/purchase_group_models.dart
import 'package:flutter/foundation.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';

/// Rappresenta un gruppo di acquisti per un mese specifico.
@immutable
class MonthlyPurchaseGroup {
  final int year;
  final int month;
  final double totalGlutenFree;
  final double totalRegular;
  final double totalOverall;
  final List<PurchaseModel> purchases;

  const MonthlyPurchaseGroup({
    required this.year,
    required this.month,
    required this.totalGlutenFree,
    required this.totalRegular,
    required this.totalOverall,
    required this.purchases,
  });
}

/// Rappresenta un gruppo di acquisti per un anno specifico.
@immutable
class YearlyPurchaseGroup {
  final int year;
  final double totalGlutenFree;
  final double totalRegular;
  final double totalOverall;
  final List<MonthlyPurchaseGroup> months;

  const YearlyPurchaseGroup({
    required this.year,
    required this.totalGlutenFree,
    required this.totalRegular,
    required this.totalOverall,
    required this.months,
  });
}

@immutable
class SearchedProductSummary {
  final String productName;
  final double totalSpent;
  final double totalQuantity;
  final int purchaseCount;
  // Manteniamo una lista delle "istanze" di acquisto per poter mostrare i dettagli
  final List<PurchaseItemModel> items;
  // E una mappa per risalire all'acquisto originale (per data e negozio)
  final Map<String, PurchaseModel> purchaseContext;

  const SearchedProductSummary({
    required this.productName,
    required this.totalSpent,
    required this.totalQuantity,
    required this.purchaseCount,
    required this.items,
    required this.purchaseContext,
  });
}
