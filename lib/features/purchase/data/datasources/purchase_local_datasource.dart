import 'package:hive/hive.dart';
import '../models/purchase_model.dart';

const String localUserId = 'local';

abstract class PurchaseLocalDataSource {
  Future<void> addPurchase(PurchaseModel purchase);
  Future<List<PurchaseModel>> getPurchases();
  Future<void> deletePurchase(String purchaseId);
  Future<void> updatePurchase(PurchaseModel purchase);
}

class PurchaseLocalDataSourceImpl implements PurchaseLocalDataSource {
  final Future<Box<PurchaseModel>> _purchaseBox;

  PurchaseLocalDataSourceImpl({required String userId})
    : _purchaseBox = Hive.openBox<PurchaseModel>('purchases_$userId');

  @override
  Future<void> addPurchase(PurchaseModel purchase) async {
    final box = await _purchaseBox;
    await box.put(purchase.id, purchase);
  }

  @override
  Future<void> deletePurchase(String purchaseId) async {
    final box = await _purchaseBox;
    await box.delete(purchaseId);
  }

  @override
  Future<void> updatePurchase(PurchaseModel purchase) async {
    final box = await _purchaseBox;
    await box.put(purchase.id, purchase);
  }

  @override
  Future<List<PurchaseModel>> getPurchases() async {
    final box = await _purchaseBox;
    final purchases = box.values.toList();
    purchases.sort((a, b) => b.date.compareTo(a.date));
    return purchases;
  }
}
