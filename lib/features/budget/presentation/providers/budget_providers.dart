import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/budget/data/models/budget_model.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

/// Un semplice provider per la box Hive dei budget.
final budgetBoxProvider = Provider((_) => Hive.box<BudgetModel>('budgets'));

/// Provider che fornisce il budget per il MESE CORRENTE.
final currentMonthBudgetProvider = FutureProvider<BudgetModel?>((ref) async {
  final box = ref.watch(budgetBoxProvider);
  final now = DateTime.now();
  final id = '${now.year}-${now.month}';
  return box.get(id);
});

/// Un piccolo modello per contenere la spesa calcolata del mese.
class MonthlySpending {
  final double spentGlutenFree;
  final double spentTotal;
  MonthlySpending(this.spentGlutenFree, this.spentTotal);
}

/// Provider che calcola la SPESA TOTALE per il MESE CORRENTE.
final currentMonthSpendingProvider = Provider<MonthlySpending>((ref) {
  // Dipende dalla lista di tutti gli acquisti
  final purchases = ref.watch(purchaseListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  // Filtra gli acquisti solo per il mese e anno correnti
  final currentMonthPurchases = purchases.where(
    (p) => p.date.year == now.year && p.date.month == now.month,
  );
  // Calcola i totali
  final spentGf = currentMonthPurchases.map((p) => p.totalGlutenFree).sum;
  final spentTotal = currentMonthPurchases.map((p) => p.total).sum;
  return MonthlySpending(spentGf, spentTotal);
});
