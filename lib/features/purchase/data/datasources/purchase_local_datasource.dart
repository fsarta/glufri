import 'package:hive/hive.dart';
import '../models/purchase_model.dart';

abstract class PurchaseLocalDataSource {
  Future<void> addPurchase(PurchaseModel purchase);
  Future<List<PurchaseModel>> getPurchases();
  Future<void> deletePurchase(String purchaseId);
  Future<void> updatePurchase(PurchaseModel purchase);
}

class PurchaseLocalDataSourceImpl implements PurchaseLocalDataSource {
  final Box<PurchaseModel> _purchaseBox;

  PurchaseLocalDataSourceImpl()
    : _purchaseBox = Hive.box<PurchaseModel>('purchases');

  @override
  Future<void> addPurchase(PurchaseModel purchase) async {
    await _purchaseBox.put(purchase.id, purchase);
  }

  @override
  Future<void> deletePurchase(String purchaseId) async {
    await _purchaseBox.delete(purchaseId);
  }

  @override
  Future<void> updatePurchase(PurchaseModel purchase) async {
    await _purchaseBox.put(purchase.id, purchase);
  }

  @override
  Future<List<PurchaseModel>> getPurchases() async {
    final purchases = _purchaseBox.values.toList();
    purchases.sort(
      (a, b) => b.date.compareTo(a.date),
    ); // Ordina dal più recente
    return purchases;
  }
}
