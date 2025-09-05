// lib/core/utils/debug_data_seeder.dart
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Una classe di utilità per generare e gestire dati finti
/// per scopi di debug.
class DebugDataSeeder {
  // Ci serve solo se kDebugMode è true, altrimenti è un albero morto.
  static Future<void> generateAndSavePurchases({int count = 50}) async {
    if (!kDebugMode) return; // Sicurezza: non eseguire mai in release.

    final random = Random();
    final uuid = const Uuid();

    // Dati finti da cui pescare
    const stores = ['Esselunga', 'Coop', 'Lidl', 'NaturaSì', 'Carrefour'];
    const productsSg = [
      'Pasta SG',
      'Biscotti SG',
      'Pane Schar',
      'Pizza SG',
      'Birra Daura',
    ];
    const productsRegular = [
      'Latte',
      'Uova',
      'Insalata',
      'Pollo',
      'Caffè',
      'Acqua',
    ];

    final Map<String, PurchaseModel> purchasesToSave = {};

    for (int i = 0; i < count; i++) {
      // 1. Crea una data casuale negli ultimi 2 anni
      final date = DateTime.now().subtract(Duration(days: random.nextInt(730)));

      // 2. Genera un numero casuale di item per questo acquisto
      final itemCount = random.nextInt(8) + 2; // Da 2 a 9 item
      final List<PurchaseItemModel> items = [];

      for (int j = 0; j < itemCount; j++) {
        final isGlutenFree =
            random.nextDouble() > 0.4; // 60% probabilità di essere SG
        final productList = isGlutenFree ? productsSg : productsRegular;
        final name = productList[random.nextInt(productList.length)];

        items.add(
          PurchaseItemModel(
            id: uuid.v4(),
            name: name,
            unitPrice:
                (random.nextDouble() * 8) + 1.5, // Prezzo tra 1.50 e 9.50
            quantity: random.nextInt(3) + 1.0, // Quantità da 1 a 3
            isGlutenFree: isGlutenFree,
          ),
        );
      }

      // 3. Calcola il totale e crea l'oggetto PurchaseModel
      final total = items.fold<double>(0.0, (sum, item) => sum + item.subtotal);
      final purchase = PurchaseModel(
        id: uuid.v4(),
        date: date,
        store: stores[random.nextInt(stores.length)],
        total: total,
        items: items,
      );

      purchasesToSave[purchase.id] = purchase;
    }

    // 4. Apri la box locale e salva i dati
    final box = await Hive.openBox<PurchaseModel>('purchases_$localUserId');
    await box.putAll(purchasesToSave);
    debugPrint('$count acquisti finti generati e salvati.');
    //await box.close(); // Chiudi per liberare risorse
  }

  /// Cancella tutti gli acquisti dalla box locale (non autenticata).
  static Future<void> clearLocalPurchases() async {
    if (!kDebugMode) return; // Sicurezza extra

    final box = await Hive.openBox<PurchaseModel>('purchases_$localUserId');
    final count = box.length;
    await box.clear();
    debugPrint('$count acquisti locali cancellati.');
    //await box.close();
  }
}
