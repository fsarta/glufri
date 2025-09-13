import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2) // <-- Nuovo typeId, assicurati sia univoco
class BudgetModel extends HiveObject {
  // Usiamo un ID composto 'anno-mese' es. '2025-09' per una facile ricerca
  @HiveField(0)
  late String id;

  @HiveField(1)
  late int year;

  @HiveField(2)
  late int month;

  // I budget sono nullable perché l'utente potrebbe non volerli impostare tutti
  @HiveField(3)
  double? glutenFreeBudget;

  @HiveField(4)
  double? totalBudget;

  BudgetModel({
    required this.id,
    required this.year,
    required this.month,
    this.glutenFreeBudget,
    this.totalBudget,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'glutenFreeBudget': glutenFreeBudget,
      'totalBudget': totalBudget,
      // Aggiungiamo un timestamp per future logiche di ordinamento
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      year: json['year'],
      month: json['month'],
      glutenFreeBudget: (json['glutenFreeBudget'] as num?)?.toDouble(),
      totalBudget: (json['totalBudget'] as num?)?.toDouble(),
    );
  }
}
