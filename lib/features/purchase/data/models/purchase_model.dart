import 'package:hive/hive.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:intl/intl.dart';

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

  String get smartTitle {
    // Regola 1: Non ci sono note utente (per ora, ma potremmo aggiungerle in futuro).
    // Partiamo dalla Regola 2.

    // Fallback: se la lista di item è vuota, restituisce un titolo generico
    if (items.isEmpty) {
      final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
      return store ?? 'Acquisto del $formattedDate';
    }

    // Trova il prodotto più costoso per subtotal
    items.sort((a, b) => b.subtotal.compareTo(a.subtotal));
    final topProduct = items.first;

    // Fallback se il negozio è null ma ci sono items
    final String baseTitle =
        store ?? 'Spesa del ${DateFormat('dd MMM').format(date)}';

    // Regola 2.1: 1 solo prodotto
    if (items.length == 1) {
      return '$baseTitle: ${topProduct.name}';
    }

    // Regola 2.2: 2-3 prodotti
    if (items.length <= 3) {
      // Concatena i primi nomi dei prodotti
      final productNames = items.map((item) => item.name).join(', ');
      return '$baseTitle: $productNames';
    }

    // Regola 2.3: Più di 3 prodotti
    final remainingCount = items.length - 1;
    return '$baseTitle: ${topProduct.name} e altri $remainingCount prodotti';
  }

  PurchaseModel({
    required this.id,
    required this.date,
    this.store,
    required this.total,
    required this.items,
    this.currency = 'EUR',
  });
}
