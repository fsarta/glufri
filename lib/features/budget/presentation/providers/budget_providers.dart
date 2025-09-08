import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/budget/data/models/budget_model.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
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

/// Contiene i valori calcolati per il budget rimanente.
/// I valori sono nullable perché un budget potrebbe non essere impostato.
class BudgetResidue {
  final double? residueGlutenFree;
  final double? residueTotal;
  const BudgetResidue({this.residueGlutenFree, this.residueTotal});
}

/// Provider che calcola la spesa totale per il mese corrente.
/// Accetta un 'purchaseIdToExclude' opzionale per escludere un acquisto
/// dal calcolo, essenziale per la modalità di modifica.
final currentMonthSpendingProvider = Provider.autoDispose
    .family<MonthlySpending, String?>((ref, purchaseIdToExclude) {
      final purchases = ref.watch(purchaseListProvider).valueOrNull ?? [];
      final now = DateTime.now();

      final currentMonthPurchases = purchases.where(
        (p) =>
            p.date.year == now.year &&
            p.date.month == now.month &&
            p.id != purchaseIdToExclude, // Escludi l'acquisto specificato
      );

      final spentGf = currentMonthPurchases.map((p) => p.totalGlutenFree).sum;
      final spentTotal = currentMonthPurchases.map((p) => p.total).sum;

      return MonthlySpending(spentGf, spentTotal);
    });

/// Provider che calcola il budget rimanente in tempo reale,
/// tenendo conto del budget impostato, della spesa passata e del carrello attuale.
final budgetResidueProvider = Provider.autoDispose<BudgetResidue>((ref) {
  // 1. Osserva il carrello attuale
  final cartState = ref.watch(cartProvider);
  final cartGfTotal = cartState.items
      .where((i) => i.isGlutenFree)
      .fold(0.0, (sum, i) => sum + i.subtotal);
  final cartTotal = cartState.total;

  // 2. Osserva il budget impostato per il mese
  // Usiamo .valueOrNull perché è un FutureProvider
  final budget = ref.watch(currentMonthBudgetProvider).valueOrNull;

  // 3. Osserva la spesa del mese ESCLUDENDO l'acquisto che stiamo modificando
  final previousSpending = ref.watch(
    currentMonthSpendingProvider(cartState.originalPurchaseId),
  );

  // 4. Calcola i residui
  double? residueGf;
  if (budget?.glutenFreeBudget != null) {
    residueGf =
        budget!.glutenFreeBudget! -
        (previousSpending.spentGlutenFree + cartGfTotal);
  }

  double? residueTotal;
  if (budget?.totalBudget != null) {
    residueTotal =
        budget!.totalBudget! - (previousSpending.spentTotal + cartTotal);
  }

  return BudgetResidue(
    residueGlutenFree: residueGf,
    residueTotal: residueTotal,
  );
});
