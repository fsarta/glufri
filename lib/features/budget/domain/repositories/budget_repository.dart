import 'package:glufri/features/budget/data/models/budget_model.dart';

abstract class BudgetRepository {
  Future<BudgetModel?> getBudget(int year, int month);
  Future<void> saveBudget(BudgetModel budget);
}
